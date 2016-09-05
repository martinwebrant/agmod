// vi: set ts=4 sw=4 :
// vim: set tw=75 :

#include <extdll.h>

cvar_t	mm_agsay        = {"mm_agsay","1", FCVAR_SERVER }; 


/*
 * Copyright (c) 2001-2002 Will Day <willday@hpgx.net>
 *
 *    This file is part of Metamod.
 *
 *    Metamod is free software; you can redistribute it and/or modify it
 *    under the terms of the GNU General Public License as published by the
 *    Free Software Foundation; either version 2 of the License, or (at
 *    your option) any later version.
 *
 *    Metamod is distributed in the hope that it will be useful, but
 *    WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with Metamod; if not, write to the Free Software Foundation,
 *    Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *    In addition, as a special exception, the author gives permission to
 *    link the code of this program with the Half-Life Game Engine ("HL
 *    Engine") and Modified Game Libraries ("MODs") developed by Valve,
 *    L.L.C ("Valve").  You must obey the GNU General Public License in all
 *    respects for all of the code used other than the HL Engine and MODs
 *    from Valve.  If you modify this file, you may extend this exception
 *    to your version of the file, but you are not obligated to do so.  If
 *    you do not wish to do so, delete this exception statement from your
 *    version.
 *
 */

#include <dllapi.h>
#include <meta_api.h>


#ifdef _WIN32
double AgTime()
{
  static LARGE_INTEGER liTimerFreq;
  static bool bInitTimer = true;
  if (bInitTimer)
  {
    bInitTimer = false;
    QueryPerformanceFrequency(&liTimerFreq);
  }

  static LARGE_INTEGER liTime;
  QueryPerformanceCounter(&liTime);
  return ((double)liTime.QuadPart) / ((double)liTimerFreq.QuadPart);
}
#else
#include <sys/time.h> 
#include <unistd.h> 
double AgTime()
{
  static struct timeval time;
  gettimeofday(&time,NULL);
  return time.tv_sec + time.tv_usec * 0.000001;
//  return (double)time.tv_sec + (double)time.tv_usec/(1000*1000)
}
#endif

void CenterSayAll(const char* pszText, float fHoldTime = 3.5, float x = -1, float y = -1, int iChannel = 5)
{
  hudtextparms_t     hText;
  memset(&hText, 0, sizeof(hText));
  hText.channel = iChannel;
  // These X and Y coordinates are just above
  //  the health meter.
  hText.x = x;
  hText.y = y;
  hText.r1 = hText.g1 = hText.b1 = 180;
  hText.a1 = 0;
  hText.r2 = hText.g2 = hText.b2 = 0;
  hText.a2 = 0;
  hText.holdTime = fHoldTime - 0.3;
  hText.effect = 2;    // Fade in/out
  hText.fadeinTime = 0.01;
  hText.fadeoutTime = fHoldTime / 5;
  hText.fxTime = 0.25;
  CENTER_SAY_PARMS(PLID, hText, pszText);
}


static float s_fSayFloodCheck = 0.0;
C_DLLEXPORT int ConnectionlessPacket( const struct netadr_s *net_from, const char *args, char *response_buffer, int *response_buffer_size )
{
  if (0 == strncmp("agsay",args,5))
  {
	  if (!CVAR_GET_POINTER("mm_agsay"))
		  CVAR_REGISTER(&mm_agsay);

    if (CVAR_GET_FLOAT("mm_agsay"))
    {
      if (s_fSayFloodCheck < AgTime())
      {
        s_fSayFloodCheck = AgTime() + 5;

        if (1 == CVAR_GET_FLOAT("mm_agsay"))
          CenterSayAll(&args[5],5,-1,0.2);
        else
          UTIL_ClientPrintAll(HUD_PRINTCENTER, &args[5]);
      }
    }

    *response_buffer_size += sprintf(response_buffer,"OK");
    RETURN_META_VALUE(MRES_HANDLED, 1);
  }

  RETURN_META_VALUE(MRES_IGNORED, 0);
}

C_DLLEXPORT void GameDLLInit(void ) 
{
	CVAR_REGISTER(&mm_agsay);

	RETURN_META(MRES_HANDLED);
}

static DLL_FUNCTIONS gFunctionTable = 
{
	GameDLLInit,					// pfnGameInit
	NULL,					// pfnSpawn
	NULL,					// pfnThink
	NULL,					// pfnUse
	NULL,					// pfnTouch
	NULL,					// pfnBlocked
	NULL,					// pfnKeyValue
	NULL,					// pfnSave
	NULL,					// pfnRestore
	NULL,					// pfnSetAbsBox

	NULL,					// pfnSaveWriteFields
	NULL,					// pfnSaveReadFields

	NULL,					// pfnSaveGlobalState
	NULL,					// pfnRestoreGlobalState
	NULL,					// pfnResetGlobalState

	NULL,					// pfnClientConnect
	NULL,					// pfnClientDisconnect
	NULL,					// pfnClientKill
	NULL,					// pfnClientPutInServer
	NULL,					// pfnClientCommand
	NULL,					// pfnClientUserInfoChanged
	NULL,					// pfnServerActivate
	NULL,					// pfnServerDeactivate

	NULL,					// pfnPlayerPreThink
	NULL,					// pfnPlayerPostThink

	NULL,					// pfnStartFrame
	NULL,					// pfnParmsNewLevel
	NULL,					// pfnParmsChangeLevel

	NULL,					// pfnGetGameDescription
	NULL,					// pfnPlayerCustomization

	NULL,					// pfnSpectatorConnect
	NULL,					// pfnSpectatorDisconnect
	NULL,					// pfnSpectatorThink
	
	NULL,					// pfnSys_Error

	NULL,					// pfnPM_Move
	NULL,					// pfnPM_Init
	NULL,					// pfnPM_FindTextureType
	
	NULL,					// pfnSetupVisibility
	NULL,					// pfnUpdateClientData
	NULL,					// pfnAddToFullPack
	NULL,					// pfnCreateBaseline
	NULL,					// pfnRegisterEncoders
	NULL,					// pfnGetWeaponData
	NULL,					// pfnCmdStart
	NULL,					// pfnCmdEnd
	ConnectionlessPacket,					// pfnConnectionlessPacket
	NULL,					// pfnGetHullBounds
	NULL,					// pfnCreateInstancedBaselines
	NULL,					// pfnInconsistentFile
	NULL,					// pfnAllowLagCompensation
};

C_DLLEXPORT int GetEntityAPI2( DLL_FUNCTIONS *pFunctionTable, int *interfaceVersion )
{
	if(!pFunctionTable) {
		UTIL_LogPrintf("GetEntityAPI2 called with null pFunctionTable");
		return(FALSE);
	}
	else if(*interfaceVersion != INTERFACE_VERSION) {
		UTIL_LogPrintf("GetEntityAPI2 version mismatch; requested=%d ours=%d", *interfaceVersion, INTERFACE_VERSION);
		//! Tell engine what version we had, so it can figure out who is out of date.
		*interfaceVersion = INTERFACE_VERSION;
		return(FALSE);
	}
	memcpy( pFunctionTable, &gFunctionTable, sizeof( DLL_FUNCTIONS ) );
	return(TRUE);
}

