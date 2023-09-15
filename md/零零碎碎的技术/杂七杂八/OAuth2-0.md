<!--
title: OAuth2.0
date: 2016-12-08 15:58:43
tags:
- Security
-->
Because of the project needs, I spent several hours in studying the OAuth2.0. It has there for a while and I have used it many times when surfing the web. Some basic ways. Considering the business security, the complete authentication should be the way to go. 
<!-- more -->
- Autorization code, client needs be authorized when talking to authorization server. client access resources directly. The most complete mode.
- Implicit mode. The simpler one. Everything is done in user-agent like browser including resource access.
- Resource owner password credentials. Resource owner give client confidential, client use it to authorize, no user-agent. 
- Client Credentials Grant. Client authorize it self as the user.

Something not certain. Client is the owner of the token when granted, how to protect the token? What if the token leaks?
