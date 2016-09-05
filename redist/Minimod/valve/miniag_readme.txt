Adrenalinegamer Mod Mini - a valve replacement package so that players can join without installing anything.

Unzip ag_66mini.zip into the Half-Life or hlds_l directory.

After you unzipped it you need to edit the /valve/server.cfg and change:
rcon_password - Remote control password.
hostname - The name to show in a gamebrowser.
sv_password - The password to enter the server.
sv_contact - Your email address.

You can also go into startup_server.cfg and change to what gamemode the server will start in.
sv_ag_gamemode ffa - Free For All
sv_ag_gamemode tdm - Team Deathmatch
sv_ag_gamemode tdmx - Team Deathmatch the AG way.
sv_ag_gamemode arena - Arena
sv_ag_gamemode arcade - Arcade
sv_ag_gamemode sgbow - Sgbow
sv_ag_gamemode instagib - Instagib
sv_ag_gamemode lms - Last Man Standing
sv_ag_gamemode lts - Last Team Standing
You can also change the allowed gamemodes.
sv_ag_allowed_gamemodes "ffa;tdm;arena;arcade;sgbow;instagib"

Do not change mp_xxx server settings in server.cfg. Add/Change them in the gamemodes configuration files in /valve/gamemodes. I repeat - do not change mp_xxx server settings in server.cfg!

RCON Admin commandlisting:
agaddadmin <admin> <password> - Add new admin.
aglistadmins - List all admins.
agdeladmin <admin> - Delete existing admin.

Other commands:
Use "help" command in console or the homepage.

Have fun!
bullit@planethalflife.com
www.planethalflife.com/agmod

Liability: (or lack thereof)
IN NO EVENT WHATSOEVER SHALL bullit@planethalflife.com BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DIRECT OR INDIRECT DAMAGES, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, LOSS OF INFORMATION) RESULTING FROM THE USE OR INABILITY TO USE THE PROGRAMS AND FILES EVEN IF bullit@planethalflife.com HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. Without limiting the generality of the foregoing, no warranty is made that the enclosed software will do anything you want it to, or be error free. USING THIS SOFTWARE IMPLIES AGREEMENT TO THESE TERMS.
This version of AdrenalineGamer Mod is provided free of charge and may be freely downloaded and redistributed under the condition that all files in the original distribution remain in the distribution and that all redistribution sites must inform (in the form of a hypertext link, etc.) users of the original place of distribution. No person or group shall profit from the redistribution of this software in any form without the consent of bullit@planethalflife.com.
In other words, do not put this program onto a CD containing shareware/freeware programs that will be sold without first consulting bullit@planethalflife.com);
