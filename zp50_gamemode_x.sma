/*================================================================================ 
     
    --------------------------------- 
    -*- [ZP] Game Mode: Infection -*- 
    --------------------------------- 
     
    This plugin is part of Zombie Plague Mod and is distributed under the 
    terms of the GNU General Public License. Check ZP_ReadMe.txt for details. 
     
================================================================================*/ 

#include <amxmodx> 
#include <fun> 
#include <fakemeta> 
#include <hamsandwich> 
#include <cs_teams_api> 
#include <cs_ham_bots_api> 
#include <zp50_gamemodes> 
#include <zp50_deathmatch> 

// HUD messages 
#define HUD_EVENT_X -1.0 
#define HUD_EVENT_Y 0.17 
#define HUD_EVENT_R 255 
#define HUD_EVENT_G 0 
#define HUD_EVENT_B 0 

new is_zombie[33]
new g_MaxPlayers 
new g_HudSync 
new g_TargetPlayer, g_TargetPlayer2, g_TargetPlayer3, g_TargetPlayer4 

new cvar_infection_chance, cvar_infection_min_players 
new cvar_infection_show_hud 
new cvar_infection_allow_respawn, cvar_respawn_after_last_human 
new cvar_zombie_first_hp_multiplier
new cvar_zombie_second_hp, cvar_zombie_third_hp , cvar_zombie_fourth_hp

new Array:g_Players;

public plugin_precache() 
{ 
    // Register game mode at precache (plugin gets paused after this) 
    register_plugin("[ZP] Game Mode: Infection", ZP_VERSION_STRING, "ZP Dev Team") 
    new game_mode_id = zp_gamemodes_register("Infection Mode") 
    zp_gamemodes_set_default(game_mode_id) 
     
    // Create the HUD Sync Objects 
    g_HudSync = CreateHudSyncObj() 
     
    g_MaxPlayers = get_maxplayers() 
     
    cvar_infection_chance = register_cvar("zp_infection_chance", "1") 
    cvar_infection_min_players = register_cvar("zp_infection_min_players", "0") 
    cvar_infection_show_hud = register_cvar("zp_infection_show_hud", "1") 
    cvar_infection_allow_respawn = register_cvar("zp_infection_allow_respawn", "1") 
    cvar_respawn_after_last_human = register_cvar("zp_respawn_after_last_human", "1") 
    cvar_zombie_first_hp_multiplier = register_cvar("zp_zombie_first_hp_multiplier", "2.0")
    cvar_zombie_second_hp = register_cvar("zp_zombie_second_hp", "3.0") 
    cvar_zombie_third_hp = register_cvar("zp_zombie_third_hp", "2.0")
    cvar_zombie_fourth_hp = register_cvar("zp_zombie_fourth_hp", "2.0")
} 

public plugin_init()
{
	g_Players = ArrayCreate()
}

// Deathmatch module's player respawn forward 
public zp_fw_deathmatch_respawn_pre(id) 
{ 
    // Respawning allowed? 
    if (!get_pcvar_num(cvar_infection_allow_respawn)) 
        return PLUGIN_HANDLED; 
     
    // Respawn if only the last human is left? 
    if (!get_pcvar_num(cvar_respawn_after_last_human) && zp_core_get_human_count() == 1) 
        return PLUGIN_HANDLED; 
     
    return PLUGIN_CONTINUE; 
} 

public zp_fw_gamemodes_choose_pre(game_mode_id, skipchecks) 
{ 
    if (!skipchecks) 
    { 
        
        // Random chance 
        if (random_num(1, get_pcvar_num(cvar_infection_chance)) != 1) 
            return PLUGIN_HANDLED; 
         
        // Min players 
        if (GetAliveCount() < get_pcvar_num(cvar_infection_min_players)) 
            return PLUGIN_HANDLED;
                 
    } 
     
    // Game mode allowed 
    return PLUGIN_CONTINUE; 
} 

/*public zp_fw_gamemodes_choose_post(game_mode_id, target_player)
{
              
    // Pick player randomly?
    g_TargetPlayer = (target_player == RANDOM_TARGET_PLAYER) ? GetRandomAlive(random_num(1, GetAliveCount())) : target_player

    g_TargetPlayer2 = (target_player == RANDOM_TARGET_PLAYER) ? GetRandomAlivehuman(random_num(1, GetAliveCountHuman())) : target_player
    
    g_TargetPlayer3 = (target_player == RANDOM_TARGET_PLAYER) ? GetRandomAlivehuman(random_num(1, GetAliveCountHuman())) : target_player
      
} */

public zp_fw_gamemodes_choose_post(game_mode_id, target_player)
{
	new id = 1;
	while (id <= g_MaxPlayers)
	{
		is_zombie[id] = 0
		id++
	}
	g_TargetPlayer = get_random_player(0)
	is_zombie[g_TargetPlayer] = 1
		 
	if (7 < get_players_alive())
	{
		g_TargetPlayer2 = get_random_player(0)
		is_zombie[g_TargetPlayer2] = 1
	}
	if (15 < get_players_alive())
	{
		g_TargetPlayer3 = get_random_player(0)
		is_zombie[g_TargetPlayer3] = 1
	}
	if (25 < get_players_alive())
	{
		g_TargetPlayer4 = get_random_player(0)
		is_zombie[g_TargetPlayer4] = 1
	}
}

public zp_fw_gamemodes_start() 
{ 
            
    // Allow infection for this game mode 
    zp_gamemodes_set_allow_infect()
    new player[32]
    new num;
    get_players(player, num, "c")
        
	
    if (num >= 26) // se for maior que 26 jogadores ou igual
    { 
       infect_player(g_TargetPlayer)
       set_user_health(g_TargetPlayer, floatround(get_user_health(g_TargetPlayer) * get_pcvar_float(cvar_zombie_first_hp_multiplier)))
       
       if (!g_TargetPlayer2 || !is_user_connected(g_TargetPlayer2)) // 1
       {
       
                g_TargetPlayer2 = get_random_player(0)
       }
       infect_player(g_TargetPlayer2)
       set_user_health(g_TargetPlayer2, floatround(get_user_health(g_TargetPlayer2) * get_pcvar_float(cvar_zombie_second_hp))) // 1
       
       
       if (!g_TargetPlayer3 || !is_user_connected(g_TargetPlayer3)) /////////////////////////////////////////////////////
       {
                  g_TargetPlayer3 = get_random_player(0)
       }
       infect_player(g_TargetPlayer3)
	
       set_user_health(g_TargetPlayer3, floatround(get_user_health(g_TargetPlayer3) * get_pcvar_float(cvar_zombie_third_hp))) 
       
       
       if (!g_TargetPlayer4 || !is_user_connected(g_TargetPlayer4))
       {
                  g_TargetPlayer4 = get_random_player(0)
       }
       infect_player(g_TargetPlayer4)
       set_user_health(g_TargetPlayer4, floatround(get_user_health(g_TargetPlayer4) * get_pcvar_float(cvar_zombie_fourth_hp)))  
       
       }
       else
       {
       	
	
       if (num >= 16) // Se for maior que 16 jogadores ou igual
       {
        infect_player(g_TargetPlayer)
        set_user_health(g_TargetPlayer, floatround(get_user_health(g_TargetPlayer) * get_pcvar_float(cvar_zombie_first_hp_multiplier)))
       
       if (!g_TargetPlayer2 || !is_user_connected(g_TargetPlayer2)) // 1
       {
       
                g_TargetPlayer2 = get_random_player(0)
       }
       infect_player(g_TargetPlayer2)
       set_user_health(g_TargetPlayer2, floatround(get_user_health(g_TargetPlayer2) * get_pcvar_float(cvar_zombie_second_hp)))
      
       if (!g_TargetPlayer3 || !is_user_connected(g_TargetPlayer3)) /////////////////////////////////////////////////////
       {
                  g_TargetPlayer3 = get_random_player(0)
       }
       infect_player(g_TargetPlayer3)	
       set_user_health(g_TargetPlayer3, floatround(get_user_health(g_TargetPlayer3) * get_pcvar_float(cvar_zombie_third_hp))) 
       }
      
      
      
      if (num >= 8) // se for maior que 8 jogadores ou igual
      {
       infect_player(g_TargetPlayer)
       set_user_health(g_TargetPlayer, floatround(get_user_health(g_TargetPlayer) * get_pcvar_float(cvar_zombie_first_hp_multiplier)))
       
       if (!g_TargetPlayer2 || !is_user_connected(g_TargetPlayer2)) // 1
       {      
                   g_TargetPlayer2 = get_random_player(0)
       }
       infect_player(g_TargetPlayer2)
       set_user_health(g_TargetPlayer2, floatround(get_user_health(g_TargetPlayer2) * get_pcvar_float(cvar_zombie_second_hp))) 
      }
            
      
      
      
      if (num >= 1)
       {
            infect_player(g_TargetPlayer)
            set_user_health(g_TargetPlayer, floatround(get_user_health(g_TargetPlayer) * get_pcvar_float(cvar_zombie_first_hp_multiplier)))
       }
     
           
    
   }
     
    // Remaining players should be humans (CTs) 
    new id 
    for (id = 1; id <= g_MaxPlayers; id++) 
    { 
        // Not alive 
        if (!is_user_alive(id)) 
            continue; 
         
        // This is our first zombie 
        if (zp_core_is_zombie(id)) 
            continue; 
         
        // Switch to CT 
        cs_set_player_team(id, CS_TEAM_CT) 
    } 
     
    if (get_pcvar_num(cvar_infection_show_hud)) 
    { 
        // Show First Zombie HUD notice 
        new name[32] 
        get_user_name(g_TargetPlayer, name, charsmax(name)) 
        set_hudmessage(HUD_EVENT_R, HUD_EVENT_G, HUD_EVENT_B, HUD_EVENT_X, HUD_EVENT_Y, 0, 0.0, 5.0, 1.0, 1.0, -1) 
        ShowSyncHudMsg(0, g_HudSync, "%L", LANG_PLAYER, "NOTICE_FIRST", name) 
    } 
} 

get_players_alive()
{
    new iAlive, id 
     
    for (id = 1; id <= g_MaxPlayers; id++) 
    { 
        if (is_user_alive(id)) 
            iAlive++ 
    } 
     
    return iAlive; 
}


// Get Alive Count -returns alive players number- 
GetAliveCount() 
{ 
    new iAlive, id 
     
    for (id = 1; id <= g_MaxPlayers; id++) 
    { 
        if (is_user_alive(id)) 
            iAlive++ 
    } 
     
    return iAlive; 
} 

stock get_random_player(zombie)
{
    new Players[32], Total
    get_players(Players, Total, "ach")
    new id = Players[random(Total)]
    
    if (zombie == 1)
    {
		if (zp_core_is_zombie(id) || is_zombie[id])
		{
			infect_player(id)
		}
		else
		{
			get_random_player(1)
		}		
     }
     return -1
    
} 

/*stock get_random_player(zombie) // default
{
    new player[32], Total
    get_players(player, Total, "ach")
    new id = player[random(Total)]
    
    if (zombie == 1)
   {
   	
	if (zp_core_is_zombie(id) || is_zombie[id])
	{
		get_random_player(1)
	}
		

	else
	{
		get_random_player(1)
	}
    }
    return -1
} */

infect_player(id)
{
	if (!zp_core_is_zombie(id))
	{
		zp_core_infect(id, id)
	}
}

public zp_fw_gamemodes_end()
{
	is_zombie[g_TargetPlayer] = 0
	g_TargetPlayer = 0
	is_zombie[g_TargetPlayer2] = 0
	g_TargetPlayer2 = 0
	is_zombie[g_TargetPlayer3] = 0
	g_TargetPlayer3 = 0
	is_zombie[g_TargetPlayer4] = 0
	g_TargetPlayer4 = 0
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1046\\ f0\\ fs16 \n\\ par }
*/
