#!/usr/bin/perl

use sigtrap;
use IO::Socket;
use IO::Select;

###############################################################################
#                                AG IRC Bot                                   #
#                             by Vi700 and t0x-                               #
#     Based on the former scripts from Saturn48 and Jan Peter Hooiveld        #
###############################################################################

# Local IP
$local_address 	= "127.0.0.1";                        #specify your ip here
$local_port 	= 28889;

# IRC Server Vars 
$irc_address 	= "irc.quakenet.eu.org";     #IRC server to connect
$irc_port	= 6668;                                   #IRC port
$irc_nickname	= "AGHL";                            #specify the bot's nick here
$irc_nickname2	= "AGHL-Bot";                    #specify the bot's 2nd nick here
$irc_channel 	= "#aghl";                  	#specify the IRC channel here

# Q-Auth (optional)
$q_nick 	= "your Q-nick";                      
$q_password	= "your Q-password";
$auth_recipient = "q\@cserve.quakenet.org";

# General Settings
$bc_log 	= "on";
$bc_mode    	= "PRIVMSG";
$bc_target  	= $irc_channel;
$bc_map    	= "unknown_map";
$hostname       = "your hostname";        #specify the hostname here
$advertisement  = "your ads";                #specify advertisement here

# connection to servers
$sock_irc = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>$irc_address, PeerPort=>$irc_port) or die "Can't open socket to irc...\n";
$sock_log = IO::Socket::INET->new(Proto=>"udp", LocalAddr=>$local_address, LocalPort=>$local_port, Type=>SOCK_DGRAM  ) or die "Can't open socket for incoming data...\n";
$selects = new IO::Select();
$selects->add($sock_irc);
$selects->add($sock_log);

# Irc Server authentication 
$sock_irc->send("USER \L$irc_nickname $irc_nickname $irc_nickname $irc_nickname\E \n");
$sock_irc->send("NICK $irc_nickname\n");

# Connection status, if connected then 1
$connected    = 0;

while (1) {
	@sets = $selects->can_read(60);
	foreach $set (@sets) {
		if ($set == $sock_irc) {
		# IRC connection
			$buf = <$set>;
			@buf = split(/\n/,$buf);
			foreach $line (@buf) {
				# Split each word in Incoming IRc buffer to different variable
				($v1,$v2,$v3,$v4,$v5,$v6) = split(/\s/,$line);
				# PING - PONG reply, otherwise bot will be disconnected by timeout
				if ($v1 =~ /PING/) {
					$sock_irc->send("PONG $v2\n");
				} elsif ($v2 =~ /002/) {
				# JOIN a channel	
					$sock_irc->send("JOIN $irc_channel\n");
					$sock_irc->send("PRIVMSG $irc_channel :Live broadcasting from $hostname ($advertisement)\n");
					$sock_irc->send("PRIVMSG $auth_recipient :auth $q_nick $q_password\n");
					$connected = 1;
				} elsif ($v2 =~ /433/) {
				# If Nickname is already existing					
					$irc_nickname = $irc_nickname2;
					$sock_irc->send("NICK $irc_nickname\n");
				} elsif ($v2 eq "KICK" && $v4 eq $irc_nickname) {
                        	# auto-join after kick
					$sock_irc->send("JOIN $irc_channel\n");
				} elsif ( $v1 =~ /ERROR/ ) { 
					print "EXCESS FLOOD";
					$selects->remove($sock_irc);	
					$sock_irc->close();
					$sock_irc = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>$irc_address, PeerPort=>$irc_port) or die "Can't open socket to irc...\n";
					$selects->add($sock_irc);
					$sock_irc->send("USER \L$irc_nickname $irc_nickname $irc_nickname $irc_nickname\E \n");
					$sock_irc->send("NICK $irc_nickname\n");
					
				}
					
			}
		
		} elsif ($set == $sock_log) {
		# HLLog server connection
			$buf = <$set>;
			$buf = substr($buf,34,length($buf) - 35);
			# print " HL Log ------------> $buf \n";
			if ($buf ne $prev_buf) {		
				$prev_buf = $buf;
				if ($buf =~ /^Started map "(.+)" .+$/) {
					$bc_map = $1;
					$irc_command = "Live broadcasting from $hostname - Map: $bc_map\n";
					$sock_irc->send("$bc_mode $bc_target :$irc_command\n");	
				
				} elsif ($buf =~ /^"(.+)<.+><(.+)><(.+)>" entered the game$/) {
                                        $player = $1;
					$wonid = $2;
					$pteam = lc($3);
                                        $player =~ s/\^[0-9]//g;
                                        foreach $tempteam (@teamlist) {
                                                if ($tempteam eq $pteam) {
                                                        $pcolor = @colorlist2[$teamcount];
                                                }
                                                $teamcount = $teamcount + 1;
                                          }
                                        $teamcount = 0;
					$irc_command = "\002$pcolor$player\003\002 \($wonid\) has entered the game ";
					$sock_irc->send("$bc_mode $bc_target :$irc_command\n");	
				
				} elsif ($buf =~ /^"(.+)<.+><(.+)><(.+)>" disconnected$/) {
					$player = $1;
					$wonid = $2;
					$pteam = lc($3);
					$player =~ s/\^[0-9]//g;
                                        foreach $tempteam (@teamlist) {
                                                if ($tempteam eq $pteam) {
                                                        $pcolor = @colorlist2[$teamcount];
                                                }
                                                $teamcount = $teamcount + 1;
                                        }
                                        $teamcount = 0;				
					$irc_command ="\002$pcolor$player\003\002 \($wonid\) disconnected\n";
					$sock_irc->send("$bc_mode $bc_target :$irc_command\n");	
														
				} elsif ($buf =~ /^"(.+)<.+><.+><(.+)>" committed suicide with "(.+)"$/) {
      					$player = $1;
					$pteam = lc($2);	
					$wep = $3;
					$player =~ s/\^[0-9]//g;
                                        foreach $tempteam (@teamlist) {
                                                if ($tempteam eq $pteam) {
                                                        $pcolor = @colorlist2[$teamcount];
                                                }
                                                $teamcount = $teamcount + 1;
                                        }
                                        $teamcount = 0;
					$irc_command ="\002$pcolor$player\003\002 suicided with $wep\n";
					$sock_irc->send("$bc_mode $bc_target :$irc_command\n");	
					
				} elsif ($buf =~ /^"(.+)<.+><.+><(.+)>" changed name to "(.+)"$/) {
					$oldn = $1;
					$newn = $3;
					$pteam = lc($2);
					$oldn =~ s/\^[0-9]//g;
					$newn =~ s/\^[0-9]//g;
					foreach $tempteam (@teamlist) {
						if ($tempteam eq $pteam) {
							$pcolor = @colorlist2[$teamcount];
						}
						$teamcount = $teamcount + 1;
					  }
					$teamcount = 0;
					$irc_command = "\002$pcolor$oldn\003\002 changed name to \002$pcolor$newn\002\003";
					$sock_irc->send("$bc_mode $bc_target :$irc_command\n");	

				} elsif ($buf =~ /^"(.+)<.+><.+><(.+)>" killed "(.+)<.+><.+><(.+)>" with "(.+)"$/) {
					$player = $1;
					$pteam = lc($2);
                                        $enemy = $3;
					$eteam = lc($4);
                                        $wep = $5;
                                        $player =~ s/\^[0-9]//g;
                                        $enemy =~ s/\^[0-9]//g;
					foreach $tempteam (@teamlist) {
						if ($tempteam eq $pteam) {
							$pcolor = @colorlist2[$teamcount];
						
                                                } elsif ($tempteam eq $eteam) {
                                                        $ecolor = @colorlist2[$teamcount];
                                                }
						$teamcount = $teamcount + 1;
					}
					$teamcount = 0;
					$irc_command = "\002$pcolor$player\002\003 killed \002$ecolor$enemy\002\003 with $wep\n";
					$sock_irc->send("$bc_mode $bc_target :$irc_command\n");	
											
				} elsif ($buf =~ /^"(.+)<.+><.+><.+>" joined team (.+)$/) {
					$player = $1;
					$newt = $2;
 					$player =~ s/\^[0-9]//g;
					$irc_command = "$player changed to team $newt";
					$sock_irc->send("$bc_mode $bc_target :$irc_command\n");	
				
				} elsif ($buf =~ /^"(.+)<.+><.+><(.+)>" committed suicide with \".+\" \(world\)$/) {
 					$player = $1;
					$pteam = lc($2);
					$player =~ s/\^[0-9]//g;
                                        foreach $tempteam (@teamlist) {
                                                if ($tempteam eq $pteam) {
                                                        $pcolor = @colorlist2[$teamcount];
                                                }
                                                $teamcount = $teamcount + 1;
                                          }
                                        $teamcount = 0;
					$irc_command = "\002$pcolor$player\003\002 killed by world";
					$sock_irc->send("$bc_mode $bc_target :$irc_command\n");	
				
				} elsif ($buf =~ /^World triggered \"Match started\"$/) {
					$irc_command = "Match started";
 					$sock_irc->send("$bc_mode $bc_target :$irc_command\n");

				} elsif ($buf =~ /^World triggered \"Time left\" \(Minutes \"(\d+)\"\) \(Seconds \"(\d+)\"\)$/) {
                                        $timeleft = "Time left\: " . $1 . "\:" . $2;
                                        
                                } elsif ($buf =~ /^World triggered \"Match over\"$/) {
					$matchover = 1;
                                        $irc_command = "\002Match is over!";
                                        $sock_irc->send("$bc_mode $bc_target :$irc_command\n");

                                } elsif ($buf =~ /^Server cvar \"pausable\" = \"1\"$/) {
                                        $irc_command = $currenttopic . "\0031 - PAUSED";
                                        $sock_irc->send("TOPIC $bc_target :$irc_command\n");
                                        $irc_command = "\002Match has been paused!";
                                        $sock_irc->send("$bc_mode $bc_target :$irc_command\n");

				} elsif ($buf =~ /^World triggered \"Score Update\" \(scores \"(.+) \"\)$/) {
					$scoretemp = $1;
					@teamlist = ();
					while ($scoretemp) {
						if ($scoretemp eq $oldscoretemp) { last; }
						$scoretemp =~ /^([^:]+):(-*)(\d+)(\s*)(.*)(\s*)$/;
						push @scorelist, $1;
						push @teamlist, lc($1);
						$sctmp2 = $2 . $3;
                                                push @scorelist, $sctmp2;
						$oldscoretemp = $scoretemp;
						$scoretemp = $5;
						$scoretemp =~ s/^\s+//;
					}
					$oldscoretemp = "";
					$scorestring = "";
					@colorlist = ("\0034\002\002", "\0032\002\002", "\0033\002\002", "\0037\002\002", "\0035\002\002", "\00313\002\002");
					@colorlist2 = ("\0034\002\002", "\0032\002\002", "\0033\002\002", "\0037\002\002", "\0035\002\002", "\00313\002\002");
					while (@scorelist) {
        					$scorecolor = shift @colorlist;
						$scoreteam = shift @scorelist;
						$scorescore = shift @scorelist;
						push @colorlist, $scorecolor;
						$scorestring = $scorestring . $scorecolor . $scoreteam . ": " . $scorescore . "\0031 - ";
					}
					
					$currenttopic = $scorestring . $timeleft;
					if ($matchover == 1) {
						$irc_command = "\0031\002Match over - Result: " . $scorestring . "gg!";
						$matchover = 0;
					} elsif ($matchover == 0) {
  	                			$irc_command = "\0031\002Score: " . $scorestring . $timeleft;
					}
						$sock_irc->send("TOPIC $bc_target :$irc_command\n");
				}
				
				 	
			}
			
			
			
			#$irc_command = $buf;
			#$sock_irc->send("$bc_mode $bc_target :$irc_command\n");
		}
	}
}
$sock_log->close();
$sock_irc->close();
exit;

sub reinit_socket_irc {
	$selects->remove($sock_irc);	
	$sock_irc->close();
	$sock_irc = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>$irc_address, PeerPort=>$irc_port) or die "Can't open socket to irc...\n";
	$selects->add($sock_irc);
	$sock_irc->send("USER \L$irc_nickname $irc_nickname $irc_nickname $irc_nickname\E \n");
	$sock_irc->send("NICK $irc_nickname\n");
}
