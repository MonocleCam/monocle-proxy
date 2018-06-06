/**********
This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the
Free Software Foundation; either version 3 of the License, or (at your
option) any later version. (See <http://www.gnu.org/copyleft/lesser.html>.)

This library is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
more details.

You should have received a copy of the GNU Lesser General Public License
along with this library; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
**********/
// Copyright (c) 1996-2018, Live Networks, Inc.  All rights reserved
// LIVE555 Proxy Server
// main program

#include "liveMedia.hh"
#include "BasicUsageEnvironment.hh"

char const* progName;
UsageEnvironment* env;
UserAuthenticationDatabase* authDB = NULL;
UserAuthenticationDatabase* authDBForREGISTER = NULL;

// Default values of command-line parameters:
int verbosityLevel = 0;
Boolean streamRTPOverTCP = False;
portNumBits tunnelOverHTTPPortNum = 0;
portNumBits rtspServerPortNum = 554;
char* username = NULL;
char* password = NULL;
Boolean proxyREGISTERRequests = True;
char* usernameForREGISTER = NULL;
char* passwordForREGISTER = NULL;

static RTSPServer* createRTSPServer(Port port) {
  if (proxyREGISTERRequests) {
    return RTSPServerWithREGISTERProxying::createNew(*env, port, authDB, authDBForREGISTER, 65, streamRTPOverTCP, verbosityLevel, username, password);
  } else {
    return RTSPServer::createNew(*env, port, authDB);
  }
}

void usage() {
  *env << "Usage: " << progName
       << " [-v|-V]"
       << " [-t|-T <http-port>]"
       << " [-p <rtspServer-port>]"
       << " [-u <username> <password>]"
       << " [-R] [-U <username-for-REGISTER> <password-for-REGISTER>]"
       << " <rtsp-url-1> ... <rtsp-url-n>\n";
  exit(1);
}

int main(int argc, char** argv) {
  // Increase the maximum size of video frames that we can 'proxy' without truncation.
  // (Such frames are unreasonably large; the back-end servers should really not be sending frames this large!)
  OutPacketBuffer::maxSize = 2000000; // bytes

  // Begin by setting up our usage environment:
  TaskScheduler* scheduler = BasicTaskScheduler::createNew();
  env = BasicUsageEnvironment::createNew(*scheduler);

  *env << " ******************************************************************\n"
       << " *             __  __  ___  _  _  ___   ___ _    ___              *\n"
       << " *            |  \\/  |/ _ \\| \\| |/ _ \\ / __| |  | __|             *\n"
       << " *            | |\\/| | (_) | .` | (_) | (__| |__| _|              *\n"
       << " *            |_|  |_|\\___/|_|\\_|\\___/ \\___|____|___|             *\n"
       << " *                                                                *\n"
       << " ******************************************************************\n"
       << " *                   MONOCLE RTSP PROXY SERVER                     \n"
       << " ******************************************************************\n"
       << " (built using the LIVE555 Streaming Media library version "
       << LIVEMEDIA_LIBRARY_VERSION_STRING
       << "; licensed under the GNU LGPL)\n\n";

  // Check command-line arguments: optional parameters, then one or more rtsp:// URLs (of streams to be proxied):
  progName = argv[0];

  while (argc > 1) {
    // Process initial command-line options (beginning with "-"):
    char* const opt = argv[1];
    if (opt[0] != '-') break; // the remaining parameters are assumed to be "rtsp://" URLs

    switch (opt[1]) {
    case 'v': { // verbose output
      verbosityLevel = 1;
      break;
    }

    case 'V': { // more verbose output
      verbosityLevel = 2;
      break;
    }

    case 't': {
      // Stream RTP and RTCP over the TCP 'control' connection.
      // (This is for the 'back end' (i.e., proxied) stream only.)
      streamRTPOverTCP = True;
      break;
    }

    case 'T': {
      // stream RTP and RTCP over a HTTP connection
      if (argc > 2 && argv[2][0] != '-') {
	// The next argument is the HTTP server port number:                                                                       
	if (sscanf(argv[2], "%hu", &tunnelOverHTTPPortNum) == 1
	    && tunnelOverHTTPPortNum > 0) {
	  ++argv; --argc;
	  break;
	}
      }

      // If we get here, the option was specified incorrectly:
      usage();
      break;
    }

    case 'p': {
      // specify a rtsp server port number 
      if (argc > 2 && argv[2][0] != '-') {
        // The next argument is the rtsp server port number:
        if (sscanf(argv[2], "%hu", &rtspServerPortNum) == 1
            && rtspServerPortNum > 0) {
          ++argv; --argc;
          break;
        }
      }

      // If we get here, the option was specified incorrectly:
      usage();
      break;
    }
    
    case 'u': { // specify a username and password (to be used if the 'back end' (i.e., proxied) stream requires authentication)
      if (argc < 4) usage(); // there's no argv[3] (for the "password")
      username = argv[2];
      password = argv[3];
      argv += 2; argc -= 2;
      break;
    }

    case 'U': { // specify a username and password to use to authenticate incoming "REGISTER" commands
      if (argc < 4) usage(); // there's no argv[3] (for the "password")
      usernameForREGISTER = argv[2];
      passwordForREGISTER = argv[3];

      if (authDBForREGISTER == NULL) authDBForREGISTER = new UserAuthenticationDatabase;
      authDBForREGISTER->addUserRecord(usernameForREGISTER, passwordForREGISTER);
      argv += 2; argc -= 2;
      break;
    }

    default: {
      usage();
      break;
    }
    }

    ++argv; --argc;
  }

  // Do some additional checking for invalid command-line argument combinations:
  if (authDBForREGISTER != NULL && !proxyREGISTERRequests) {
    *env << "The '-U <username> <password>' option can be used only with -R\n";
    usage();
  }
  if (streamRTPOverTCP) {
    if (tunnelOverHTTPPortNum > 0) {
      *env << "The -t and -T options cannot both be used!\n";
      usage();
    } else {
      tunnelOverHTTPPortNum = (portNumBits)(~0); // hack to tell "ProxyServerMediaSession" to stream over TCP, but not using HTTP
    }
  }

#ifdef ACCESS_CONTROL
  // To implement client access control to the RTSP server, do the following:
  authDB = new UserAuthenticationDatabase;
  //authDB->addUserRecord("username1", "password1"); // replace these with real strings
      // Repeat this line with each <username>, <password> that you wish to allow access to the server.
#endif

  // Create the RTSP server. Try first with the configured port number,
  // and then with the default port number (554) if different,
  // and then with the alternative port number (8554):
  RTSPServer* rtspServer;
  rtspServer = createRTSPServer(rtspServerPortNum);
  if (rtspServer == NULL) {
    if (rtspServerPortNum != 554) {
      *env << "Unable to create a RTSP server with port number " << rtspServerPortNum << ": " << env->getResultMsg() << "\n";
      *env << "Trying instead with the standard port numbers (554 and 8554)...\n";

      rtspServerPortNum = 554;
      rtspServer = createRTSPServer(rtspServerPortNum);
    }
  }
  if (rtspServer == NULL) {
    rtspServerPortNum = 8554;
    rtspServer = createRTSPServer(rtspServerPortNum);
  }
  if (rtspServer == NULL) {
    *env << "Failed to create RTSP server: " << env->getResultMsg() << "\n";
    exit(1);
  }

//  if (proxyREGISTERRequests) {
//    *env << "(We handle incoming \"REGISTER\" requests on port " << rtspServerPortNum << ")\n";
//  }

  // Now, enter the event loop:
  env->taskScheduler().doEventLoop(); // does not return

  return 0; // only to prevent compiler warning
}
