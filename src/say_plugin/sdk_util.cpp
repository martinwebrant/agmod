// vi: set ts=4 sw=4 :
// vim: set tw=75 :

// sdk_util.cpp - utility routines from HL SDK util.cpp

// Selected portions of dlls/util.cpp from SDK 2.1.
// Functions copied from there as needed...

/***
*
*	Copyright (c) 1999, 2000 Valve LLC. All rights reserved.
*	
*	This product contains software technology licensed from Id 
*	Software, Inc. ("Id Technology").  Id Technology (c) 1996 Id Software, Inc. 
*	All Rights Reserved.
*
*   Use, distribution, and modification of this source code and/or resulting
*   object code is restricted to non-commercial enhancements to products from
*   Valve LLC.  All other use, distribution, or modification is prohibited
*   without written permission from Valve LLC.
*
****/
/*

===== util.cpp ========================================================

  Utility code.  Really not optional after all.

*/

#include <extdll.h>
#include "sdk_util.h"
#include <cbase.h>
#include <meta_api.h>

#include <string.h>			// for strncpy(), etc

char* UTIL_VarArgs( char *format, ... )
{
	va_list		argptr;
	static char		string[1024];
	
	va_start (argptr, format);
	vsprintf (string, format,argptr);
	va_end (argptr);

	return string;
}
	

//=========================================================
// UTIL_LogPrintf - Prints a logged message to console.
// Preceded by LOG: ( timestamp ) < message >
//=========================================================
void UTIL_LogPrintf( char *fmt, ... )
{
	va_list			argptr;
	static char		string[1024];
	
	va_start ( argptr, fmt );
	vsprintf ( string, fmt, argptr );
	va_end   ( argptr );

	// Print to server console
	ALERT( at_logged, "%s", string );
}


void UTIL_HudMessage(CBaseEntity *pEntity, const hudtextparms_t &textparms, 
		const char *pMessage)
{
	if ( !pEntity )
		return;

	MESSAGE_BEGIN( MSG_ONE, SVC_TEMPENTITY, NULL, ENT(pEntity->pev) );
		WRITE_BYTE( TE_TEXTMESSAGE );
		WRITE_BYTE( textparms.channel & 0xFF );

		WRITE_SHORT( FixedSigned16( textparms.x, 1<<13 ) );
		WRITE_SHORT( FixedSigned16( textparms.y, 1<<13 ) );
		WRITE_BYTE( textparms.effect );

		WRITE_BYTE( textparms.r1 );
		WRITE_BYTE( textparms.g1 );
		WRITE_BYTE( textparms.b1 );
		WRITE_BYTE( textparms.a1 );

		WRITE_BYTE( textparms.r2 );
		WRITE_BYTE( textparms.g2 );
		WRITE_BYTE( textparms.b2 );
		WRITE_BYTE( textparms.a2 );

		WRITE_SHORT( FixedUnsigned16( textparms.fadeinTime, 1<<8 ) );
		WRITE_SHORT( FixedUnsigned16( textparms.fadeoutTime, 1<<8 ) );
		WRITE_SHORT( FixedUnsigned16( textparms.holdTime, 1<<8 ) );

		if ( textparms.effect == 2 )
			WRITE_SHORT( FixedUnsigned16( textparms.fxTime, 1<<8 ) );
		
		if ( strlen( pMessage ) < 512 )
		{
			WRITE_STRING( pMessage );
		}
		else
		{
			char tmp[512];
			strncpy( tmp, pMessage, 511 );
			tmp[511] = 0;
			WRITE_STRING( tmp );
		}
	MESSAGE_END();
}

short FixedSigned16( float value, float scale )
{
	int output;

	output = (int) (value * scale);

	if ( output > 32767 )
		output = 32767;

	if ( output < -32768 )
		output = -32768;

	return (short)output;
}

unsigned short FixedUnsigned16( float value, float scale )
{
	int output;

	output = (int) (value * scale);
	if ( output < 0 )
		output = 0;
	if ( output > 0xFFFF )
		output = 0xFFFF;

	return (unsigned short)output;
}


// returns a CBaseEntity pointer to a player by index.  Only returns if the player is spawned and connected
// otherwise returns NULL
// Index is 1 based
CBaseEntity	*UTIL_PlayerByIndex( int playerIndex )
{
	CBaseEntity *pPlayer = NULL;

	if ( playerIndex > 0 && playerIndex <= gpGlobals->maxClients )
	{
		edict_t *pPlayerEdict = INDEXENT( playerIndex );
		if ( pPlayerEdict && !pPlayerEdict->free )
		{
			pPlayer = CBaseEntity::Instance( pPlayerEdict );
		}
	}
	
	return pPlayer;
}


					 
int gmsgTextMsg = 0;
void UTIL_ClientPrintAll( int msg_dest, const char *msg_name, const char *param1, const char *param2, const char *param3, const char *param4 )
{
  if (!gmsgTextMsg)
    gmsgTextMsg = GET_USER_MSG_ID(PLID, "TextMsg", NULL);

	MESSAGE_BEGIN( MSG_ALL, gmsgTextMsg );
		WRITE_BYTE( msg_dest );
		WRITE_STRING( msg_name );
    if ( param1 )
			WRITE_STRING( param1 );
		if ( param2 )
			WRITE_STRING( param2 );
		if ( param3 )
			WRITE_STRING( param3 );
		if ( param4 )
			WRITE_STRING( param4 );
	MESSAGE_END();
}
