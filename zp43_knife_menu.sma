#include <amxmodx>
#include <amxmisc>
#include <fakemeta> 
#include <fun>
#include <zombieplague> 
#include <hamsandwich>
#include <engine> 

#define PLUGIN  "Bn_zp_knife"                                                                                                     
#define VERSION "2.5"                                     
#define AUTHOR  "NEO"         

#define TASK_FBURN     100
#define TASK_INFO      333
#define ID_FBURN      ( taskid - TASK_FBURN )            
#define MAX_CLIENTS               32
new bool:g_fRoundEnd                                       
new g_flameSpr, g_smokeSpr, g_burning_duration[ MAX_CLIENTS + 1 ]         

#define PREFIKS "!t[!gZP!t]"   
#define SOZDATEL_FLAG   ADMIN_RCON                                                                                             
#define ADMIN_FLAG      ADMIN_BAN                                            
#define VIP_FLAG        ADMIN_LEVEL_H                               

new key0 = MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0

new g_knife1[33],g_knife2[33],g_knife3[33],g_knife4[33],g_knife5[33],g_knife6[33]
new s_knife0[33],s_knife1[33],s_knife2[33],s_knife3[33],s_knife4[33],s_knife5[33],s_knife6[33] 
new g_block[33]        
new bool:g_block_knife_menu[33]                           

new Knife_v_0[]    = "models/v_knife.mdl"                                               
new Knife_v_1[]    = "models/sG_Knifes/Knifes/Knife_v_1.mdl"                                                                                                                                                
new Knife_v_2[]    = "models/sG_Knifes/Knifes/Knife_v_2.mdl"                                                                                      
new Knife_v_3[]    = "models/sG_Knifes/Knifes/Knife_v_3.mdl"                                                                                                                                                                             
new Knife_v_4[]    = "models/sG_Knifes/Knifes/Knife_v_4.mdl"                                                                                
new Knife_v_5[]    = "models/sG_Knifes/Knifes/Knife_v_5.mdl"                                                                                                                                                                             
new Knife_v_6[]    = "models/sG_Knifes/Knifes/Knife_v_6.mdl"          

new Knife_p_0[]    = "models/p_knife.mdl"                                                                                   
new Knife_p_1[]    = "models/sG_Knifes/Knifes/Knife_p_1.mdl"                                                                                                                                                
new Knife_p_2[]    = "models/sG_Knifes/Knifes/Knife_p_2.mdl"                                                                                      
new Knife_p_3[]    = "models/sG_Knifes/Knifes/Knife_p_3.mdl"                                                                                                                                                                             
new Knife_p_4[]    = "models/sG_Knifes/Knifes/Knife_p_4.mdl"                                                                                
new Knife_p_5[]    = "models/sG_Knifes/Knifes/Knife_p_5.mdl"                                                                                                                                                                             
new Knife_p_6[]    = "models/sG_Knifes/Knifes/Knife_p_6.mdl"

new bool:nextround[33] // block menu

new Buy_Sound[]    = "items/gunpickup2.wav" 

new const Knife1_sound[][] =                                                        
{                                                                                 
"7erva4ok/zmmod/knife/Knife_1_draw.wav",
"7erva4ok/zmmod/knife/Knife_1_hit.wav",
"7erva4ok/zmmod/knife/Knife_1_hitwall.wav",                          
"7erva4ok/zmmod/knife/Knife_1_slash.wav",                                                       
"7erva4ok/zmmod/knife/Knife_1_stab.wav"
}

new const Knife2_sound[][] =                                                                                              
{                                                                                 
"7erva4ok/zmmod/knife/Knife_2_draw.wav",
"7erva4ok/zmmod/knife/Knife_2_hit.wav",
"7erva4ok/zmmod/knife/Knife_2_hitwall.wav",                    
"7erva4ok/zmmod/knife/Knife_2_slash.wav",                                                       
"7erva4ok/zmmod/knife/Knife_2_stab.wav"
}

new const Knife3_sound[][] =
{                                                                                 
"7erva4ok/zmmod/knife/Knife_3_draw.wav",
"7erva4ok/zmmod/knife/Knife_3_hit.wav",
"7erva4ok/zmmod/knife/Knife_3_hitwall.wav",                    
"7erva4ok/zmmod/knife/Knife_3_slash.wav",                                                       
"7erva4ok/zmmod/knife/Knife_3_stab.wav"
}

new const Knife4_sound[][] =
{                                                                                 
"7erva4ok/zmmod/knife/Knife_4_draw.wav",
"7erva4ok/zmmod/knife/Knife_4_hit.wav",
"7erva4ok/zmmod/knife/Knife_4_hitwall.wav",                    
"7erva4ok/zmmod/knife/Knife_4_slash.wav",                                                       
"7erva4ok/zmmod/knife/Knife_4_stab.wav"
}

new const Knife5_sound[][] =
{                                                                                 
"7erva4ok/zmmod/knife/Knife_5_draw.wav",
"7erva4ok/zmmod/knife/Knife_5_hit.wav",
"7erva4ok/zmmod/knife/Knife_5_hitwall.wav",                    
"7erva4ok/zmmod/knife/Knife_5_slash.wav",                                                       
"7erva4ok/zmmod/knife/Knife_5_stab.wav"
} 

new const Knife6_sound[][] =
{                                                                                 
"7erva4ok/zmmod/knife/Knife_6_draw.wav",
"7erva4ok/zmmod/knife/Knife_6_hit.wav",
"7erva4ok/zmmod/knife/Knife_6_hitwall.wav",                    
"7erva4ok/zmmod/knife/Knife_6_slash.wav",                                                       
"7erva4ok/zmmod/knife/Knife_6_stab.wav"
}

new speed_knife1,speed_knife2,speed_knife3,speed_knife4,speed_knife5,speed_knife6 // Speed

new grav_knife1,grav_knife2,grav_knife3,grav_knife4,grav_knife5,grav_knife6 //Gravity

// new g_line_sozdatel_R,g_line_sozdatel_G,g_line_sozdatel_B,g_line_admin_R,g_line_admin_G,g_line_admin_B,g_line_vip_R,g_line_vip_G,g_line_vip_B // Lines (circle) 

new gump_vip,gump_admin,gump_sozdatel // Extra Jumps

new dmg_knife1,dmg_knife2,dmg_knife3,dmg_knife4,dmg_knife5,dmg_knife6 // DMG 

new knock_knife1, knock_knife2, knock_knife3, knock_knife4, knock_knife5, knock_knife6 // Knockback

//new g_off_line_sozdatel,g_off_line_admin,g_off_line_vip // Lines (circle) [Removed]

new g_fire_time,g_fire_damage // Burn time 

//new g_freeze_wait[33],g_frozen[33]
//new g_time_freeze,g_time_freeze_wait

new jumpnum[33] = 0                                                       
new bool:dojump[33] = false                                                     
new g_jump[33]                                                                    
//new BeaconSprite
new g_sp[33]

// new boolean variable 
new bool:g_block_knife[33] = true

public plugin_init()                                                                         
{                                                                                                                           
register_plugin(PLUGIN,VERSION,AUTHOR)                                                  
register_menu("Menu_0", key0, "Key_0")                                                           

register_event("CurWeapon", "weapon_charge", "be","1=1")
register_forward(FM_PlayerPreThink, "fw_PlayerPreThink")                             
RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage") 
register_forward(FM_EmitSound, "CEntity__EmitSound")
// To enable menu every round 
// this will detect new round and make it true at round start
register_event("HLTV", "event_NewRound", "a", "1=0", "2=0")

register_clcmd("drop","next_sp")                                                                  
register_clcmd("say /knife","start_menu")
register_clcmd("knife","start_menu")

set_cvar_string("bn_knife",VERSION)
// Скорости ножей                                                                                                                                        
// Гравитации ножей                                                                                                                                   
// Урон ножей                                                                                   
dmg_knife1 = register_cvar("zp_knife1_dmg", "2.0")                  
dmg_knife2 = register_cvar("zp_knife2_dmg", "2.0")                                              
dmg_knife3 = register_cvar("zp_knife3_dmg", "5.0")                                  
dmg_knife4 = register_cvar("zp_knife4_dmg", "6.0") 
dmg_knife5 = register_cvar("zp_knife5_dmg", "7.0")              
dmg_knife6 = register_cvar("zp_knife6_dmg", "8.0") 

knock_knife1 = register_cvar("zp_knock_knife1", "2.0")
knock_knife2 = register_cvar("zp_knock_knife2", "2.0")
knock_knife3 = register_cvar("zp_knock_knife3", "3.0")
knock_knife4 = register_cvar("zp_knock_knife4", "4.0")
knock_knife5 = register_cvar("zp_knock_knife5", "5.0")
knock_knife6 = register_cvar("zp_knock_knife6", "6.0")


// Цвет круга при прижке (Создатель)                                                                                                                                  
// Цвет круга при прижке (Админ)                                                                                                                                                                                 
// Отключение кругов                                                                                                                                              
// Прыжки                                                                                 
// gump_sozdatel = register_cvar("zp_maxjumps_sozdatel","5")                                                                                                      
// gump_admin = register_cvar("zp_maxjumps_admin","3")                                            
gump_vip = register_cvar("zp_maxjumps_vip","2")                                                            
// Способности ножей                                                              
g_fire_time = register_cvar("zp_burn_time","5")                                                     
g_fire_damage = register_cvar("zp_burn_damage","15")

// g_time_freeze = register_cvar("zp_freeze_time","3.0") 
//  g_time_freeze_wait = register_cvar("zp_freeze_wait","10.0")
}

public plugin_cfg()                                                                             
{                                                                               
new szCfgDir[64], szFile[192];                                                             
get_configsdir(szCfgDir, charsmax(szCfgDir));
formatex(szFile,charsmax(szFile),"%s/bn_plague/bn_knife.cfg",szCfgDir); 
if(file_exists(szFile))                 
server_cmd("exec %s", szFile);                                                              
}

public plugin_precache()                                                                            
{   
precache_model(Knife_v_0)                                   
precache_model(Knife_v_1)                                                                                                              
precache_model(Knife_v_2)                                                                                                                     
precache_model(Knife_v_3)                                                                                       
precache_model(Knife_v_4)                                                                                                   
precache_model(Knife_v_5)                                                                                       
precache_model(Knife_v_6)                                                         

precache_model(Knife_p_0)                                                           
precache_model(Knife_p_1)                                                                                                              
precache_model(Knife_p_2)                                                                                                                     
precache_model(Knife_p_3)                                                                                       
precache_model(Knife_p_4)                                                                                                   
precache_model(Knife_p_5)                                                                                       
precache_model(Knife_p_6)

for(new i = 0; i < sizeof Knife1_sound; i++)
precache_sound(Knife1_sound[i])

for(new i = 0; i < sizeof Knife2_sound; i++)
precache_sound(Knife2_sound[i])                                                               

for(new i = 0; i < sizeof Knife3_sound; i++)                                          
precache_sound(Knife3_sound[i])

for(new i = 0; i < sizeof Knife4_sound; i++)
precache_sound(Knife4_sound[i])              

for(new i = 0; i < sizeof Knife5_sound; i++)
	precache_sound(Knife5_sound[i])
	
	for(new i = 0; i < sizeof Knife6_sound; i++)
		precache_sound(Knife6_sound[i])
	
	//BeaconSprite = precache_model("sprites/shockwave.spr")
	g_flameSpr = precache_model( "sprites/flame.spr" )
	g_smokeSpr = precache_model( "sprites/black_smoke3.spr" )                             
}                                           

public client_putinserver(id)            
{
	jumpnum[id] = 0                           
	dojump[id] = false
	g_sp[id] = true
	
	g_knife1[id] = false                                                 
	g_knife2[id] = false                            
	g_knife3[id] = false                        
	g_knife4[id] = false                          
	g_knife5[id] = false
	g_knife6[id] = false
	
	s_knife0[id] = true
	s_knife1[id] = false     
	s_knife2[id] = false             
	s_knife3[id] = false                                               
	s_knife4[id] = false                 
	s_knife5[id] = false                              
	s_knife6[id] = false
	g_block_knife[id] = true
}

public client_disconnected(id)
{
	jumpnum[id] = 0
	dojump[id] = false 
}

// at start of every round make the variable true for everyone 
public event_NewRound()
{
	new i
	for (i=1; i<=33; i++)
	{
		g_block_knife[i] = true
	}
	
}

public fw_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	if(!is_user_connected(attacker)) return HAM_IGNORED                                 
	if(zp_get_user_zombie(attacker)) return HAM_IGNORED                              
	new weapon = get_user_weapon(attacker)
	if(weapon == CSW_KNIFE && g_knife6[attacker])                                                                 
	{                                                                 
		SetHamParamFloat(4, damage * get_pcvar_float(dmg_knife6))                                  
		if(g_sp[attacker])
		{
			if( !task_exists( victim + TASK_FBURN ) )                                                            
			{                                                                                                             
				g_burning_duration[victim] += get_pcvar_num(g_fire_time) * 5                                          
				set_task(0.1, "CTask__BurningFlame", victim + TASK_FBURN, _, _, "b" )
			}                                                                                                         
		}                                                                                                        
		
	}                                                                                                    
	if(weapon == CSW_KNIFE && g_knife5[attacker])                                              
	{                                                                                               
		SetHamParamFloat(4, damage * get_pcvar_float(dmg_knife5))
		
		new Float:vec[3];
		new Float:oldvelo[3];
		pev(victim, pev_velocity, oldvelo);
		create_velocity_vector(victim , attacker , vec);
		vec[0] += oldvelo[0] + get_pcvar_float(knock_knife5);
		vec[1] += oldvelo[1] + 0;
		set_pev(victim, pev_velocity, vec); 
	}                                                                                                          
	if(weapon == CSW_KNIFE && g_knife4[attacker])
	{    
		SetHamParamFloat(4, damage * get_pcvar_float(dmg_knife4))
		
		new Float:vec[3];
		new Float:oldvelo[3];
		pev(victim, pev_velocity, oldvelo);
		create_velocity_vector(victim , attacker , vec);
		vec[0] += oldvelo[0] + get_pcvar_float(knock_knife4);
		vec[1] += oldvelo[1] + 0;
		set_pev(victim, pev_velocity, vec); 
	}
	if(weapon == CSW_KNIFE && g_knife3[attacker])
	{                                                                                       
		SetHamParamFloat(4, damage * get_pcvar_float(dmg_knife3))
		
		new Float:vec[3];
		new Float:oldvelo[3];
		pev(victim, pev_velocity, oldvelo);
		create_velocity_vector(victim , attacker , vec);
		vec[0] += oldvelo[0] + get_pcvar_float(knock_knife3);
		vec[1] += oldvelo[1] + 0;
		set_pev(victim, pev_velocity, vec);
	}                                                
	if(weapon == CSW_KNIFE && g_knife2[attacker])
	{     
		SetHamParamFloat(4, damage * get_pcvar_float(dmg_knife2))    
		
		new Float:vec[3];
		new Float:oldvelo[3];
		pev(victim, pev_velocity, oldvelo);
		create_velocity_vector(victim , attacker , vec);
		vec[0] += oldvelo[0] + get_pcvar_float(knock_knife2);
		vec[1] += oldvelo[1] + 0;
		set_pev(victim, pev_velocity, vec);
	}                                                                                                       
	if(weapon == CSW_KNIFE && g_knife1[attacker])                                    
	{     
		SetHamParamFloat(4, damage * get_pcvar_float(dmg_knife1))
		
		new Float:vec[3];
		new Float:oldvelo[3];
		pev(victim, pev_velocity, oldvelo);
		create_velocity_vector(victim , attacker , vec);
		vec[0] += oldvelo[0] + get_pcvar_float(knock_knife1);
		vec[1] += oldvelo[1] + 0;
		set_pev(victim, pev_velocity, vec);
	}                                                          
	return HAM_IGNORED                                                                 
}

/*public fw_PlayerPreThink(id)                                                                           
{                                                                                                  
	new weapon = get_user_weapon(id)        
	if(weapon == CSW_KNIFE)                                                    
	{ 
		if(g_knife1[id])                                                   
		{ 
			g_jump[id] = 0 
			set_user_maxspeed(id, get_pcvar_float(speed_knife1)) 
			if ((pev(id, pev_button) & IN_JUMP) && !(pev(id, pev_oldbuttons) & IN_JUMP))           
			{
				new flags = pev(id, pev_flags)
				new waterlvl = pev(id, pev_waterlevel)                                                                                          
				if (!(flags & FL_ONGROUND))     
					return FMRES_IGNORED               
				if (flags & FL_WATERJUMP)                                                
					return FMRES_IGNORED                                                           
				if (waterlvl > 1)                                     
					return FMRES_IGNORED                                                            
				new Float:fVelocity[3]
				pev(id, pev_velocity, fVelocity)                             
				fVelocity[2] = get_pcvar_float(grav_knife1)                        
				set_pev(id, pev_velocity, fVelocity)
				set_pev(id, pev_gaitsequence, 6) 
			}
		}                                                                                                
		if(g_knife2[id])                                                     
		{
			g_jump[id] = 0 
			set_user_maxspeed(id, get_pcvar_float(speed_knife2))
			if ((pev(id, pev_button) & IN_JUMP) && !(pev(id, pev_oldbuttons) & IN_JUMP))
			{
				new flags = pev(id, pev_flags)
				new waterlvl = pev(id, pev_waterlevel)
				if (!(flags & FL_ONGROUND))     
					return FMRES_IGNORED               
				if (flags & FL_WATERJUMP)                                                
					return FMRES_IGNORED
				if (waterlvl > 1)
					return FMRES_IGNORED                    
				new Float:fVelocity[3] 
				pev(id, pev_velocity, fVelocity)
				fVelocity[2] = get_pcvar_float(grav_knife2)                        
				set_pev(id, pev_velocity, fVelocity)
				set_pev(id, pev_gaitsequence, 6) 
			}
		}
		if(g_knife3[id])
		{
			g_jump[id] = 0 
			set_user_maxspeed(id, get_pcvar_float(speed_knife3))
			if ((pev(id, pev_button) & IN_JUMP) && !(pev(id, pev_oldbuttons) & IN_JUMP))
			{
				new flags = pev(id, pev_flags)
				new waterlvl = pev(id, pev_waterlevel)
				if (!(flags & FL_ONGROUND))     
					return FMRES_IGNORED               
				if (flags & FL_WATERJUMP)                                                
					return FMRES_IGNORED
				if (waterlvl > 1)
					return FMRES_IGNORED                    
				new Float:fVelocity[3] 
				pev(id, pev_velocity, fVelocity)
				fVelocity[2] = get_pcvar_float(grav_knife3)                        
				set_pev(id, pev_velocity, fVelocity)
				set_pev(id, pev_gaitsequence, 6) 
			}
		}
		if(g_knife4[id])
		{                                               
			g_jump[id] = get_pcvar_num(gump_vip)                   
			set_user_maxspeed(id, get_pcvar_float(speed_knife4))
			if ((pev(id, pev_button) & IN_JUMP) && !(pev(id, pev_oldbuttons) & IN_JUMP))
			{
				new flags = pev(id, pev_flags)                                                            
				new waterlvl = pev(id, pev_waterlevel)
				if (!(flags & FL_ONGROUND))     
					return FMRES_IGNORED               
				if (flags & FL_WATERJUMP)                                                
					return FMRES_IGNORED
				if (waterlvl > 1)
					return FMRES_IGNORED                    
				new Float:fVelocity[3]  
				pev(id, pev_velocity, fVelocity)
				fVelocity[2] = get_pcvar_float(grav_knife4)                        
				set_pev(id, pev_velocity, fVelocity)
				set_pev(id, pev_gaitsequence, 6) 
			}
		}
		if(g_knife5[id])
		{
			g_jump[id] = get_pcvar_num(gump_admin)
			set_user_maxspeed(id, get_pcvar_float(speed_knife5))
			if ((pev(id, pev_button) & IN_JUMP) && !(pev(id, pev_oldbuttons) & IN_JUMP))                             
			{
				new flags = pev(id, pev_flags)
				new waterlvl = pev(id, pev_waterlevel)                                                          
				if (!(flags & FL_ONGROUND))     
					return FMRES_IGNORED               
				if (flags & FL_WATERJUMP)                                                                
					return FMRES_IGNORED                                                                         
				if (waterlvl > 1)
					return FMRES_IGNORED                    
				new Float:fVelocity[3] 
				pev(id, pev_velocity, fVelocity)                                                                
				fVelocity[2] = get_pcvar_float(grav_knife5)                        
				set_pev(id, pev_velocity, fVelocity)
				set_pev(id, pev_gaitsequence, 6)                   
			}                                                                                                           
		}                                                                                  
		if(g_knife6[id])                                                                                                    
		{                                                                                      
			set_task(0.5, "Ability", id + TASK_INFO)
			g_jump[id] = get_pcvar_num(gump_sozdatel)                                                                 
			set_user_maxspeed(id, get_pcvar_float(speed_knife6))                                                              
			if ((pev(id, pev_button) & IN_JUMP) && !(pev(id, pev_oldbuttons) & IN_JUMP))                   
			{                                                                             
				new flags = pev(id, pev_flags)
				new waterlvl = pev(id, pev_waterlevel)
				if (!(flags & FL_ONGROUND))                                                                       
					return FMRES_IGNORED                                                     
				if (flags & FL_WATERJUMP)                                                                     
					return FMRES_IGNORED
				if (waterlvl > 1)                                                                           
					return FMRES_IGNORED                                      
				new Float:fVelocity[3]                                    
				pev(id, pev_velocity, fVelocity)
				fVelocity[2] = get_pcvar_float(grav_knife6)                        
				set_pev(id, pev_velocity, fVelocity)               
				set_pev(id, pev_gaitsequence, 6) 
			}
		}
	}
	else                                                     
	{
		g_jump[id] = 0
	}
	return FMRES_IGNORED
}   */                                                             

public zp_user_infected_post(id)                              
{
	g_knife1[id] = false                                                 
	g_knife2[id] = false
	g_knife3[id] = false
	g_knife4[id] = false                          
	g_knife5[id] = false
	g_knife6[id] = false
	
	s_knife0[id] = true
	s_knife1[id] = false     
	s_knife2[id] = false                               
	s_knife3[id] = false                                               
	s_knife4[id] = false                 
	s_knife5[id] = false                              
	s_knife6[id] = false
}

public weapon_charge(id)                                      
{                                                                    
	new weaponid 
	weaponid = read_data(2)
	
	if(!zp_get_user_zombie(id))                                    
	{                                              
		if(weaponid == CSW_KNIFE)                                                               
		{
			if(g_knife1[id])                                                                        
			{
				set_pev(id, pev_viewmodel2, Knife_v_1)                                                                                 
				set_pev(id, pev_weaponmodel2, Knife_p_1)               
			}
			if(g_knife2[id])                                                                    
			{                                                                                      
				set_pev(id, pev_viewmodel2, Knife_v_2)                                                                                 
				set_pev(id, pev_weaponmodel2, Knife_p_2) 
			}
			if(g_knife3[id])
			{
				set_pev(id, pev_viewmodel2, Knife_v_3)                                                                                 
				set_pev(id, pev_weaponmodel2, Knife_p_3)
			}
			if(g_knife4[id])                                                                                  
			{
				set_pev(id, pev_viewmodel2, Knife_v_4)                                                                                 
				set_pev(id, pev_weaponmodel2, Knife_p_4)
			}                                                                         
			if(g_knife5[id])
			{
				set_pev(id, pev_viewmodel2, Knife_v_5)                                                                                 
				set_pev(id, pev_weaponmodel2, Knife_p_5)
			}
			if(g_knife6[id])
			{
				set_pev(id, pev_viewmodel2, Knife_v_6)                                                                                 
				set_pev(id, pev_weaponmodel2, Knife_p_6)
			}
		}                                                                      
	}
}

public CEntity__EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if (!is_user_connected(id)) 
		return HAM_IGNORED                                                                              
	
	if (sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i')
	{    
		if (sample[14] == 'd')                                                                                                   
		{                                                             
			if(g_knife1[id])
				emit_sound(id, channel, Knife1_sound[0], volume, attn, flags, pitch)
			if(g_knife2[id])                                                                      
				emit_sound(id, channel, Knife2_sound[0], volume, attn, flags, pitch)                     
			if(g_knife3[id])                                                                                   
				emit_sound(id, channel, Knife3_sound[0], volume, attn, flags, pitch)                                    
			if(g_knife4[id])
				emit_sound(id, channel, Knife4_sound[0], volume, attn, flags, pitch)                                    
			if(g_knife5[id])
				emit_sound(id, channel, Knife5_sound[0], volume, attn, flags, pitch)
			if(g_knife6[id])
				emit_sound(id, channel, Knife6_sound[0], volume, attn, flags, pitch)
		}                                                                                      
		else if (sample[14] == 'h')                                                                               
		{
			if (sample[17] == 'w') 
			{
				if(g_knife1[id])                                                                                        
					emit_sound(id, channel, Knife1_sound[2], volume, attn, flags, pitch)
				if(g_knife2[id])
					emit_sound(id, channel, Knife2_sound[2], volume, attn, flags, pitch)
				if(g_knife3[id])
					emit_sound(id, channel, Knife3_sound[2], volume, attn, flags, pitch)            
				if(g_knife4[id])                                                                                
					emit_sound(id, channel, Knife4_sound[2], volume, attn, flags, pitch)
				if(g_knife5[id])
					emit_sound(id, channel, Knife5_sound[2], volume, attn, flags, pitch)
				if(g_knife6[id])
					emit_sound(id, channel, Knife6_sound[2], volume, attn, flags, pitch)
			}
			else
			{                                                                                                                       
				if(g_knife1[id])                                                                                               
					emit_sound(id, channel, Knife1_sound[1], volume, attn, flags, pitch)                          
				if(g_knife2[id])
					emit_sound(id, channel, Knife2_sound[1], volume, attn, flags, pitch)
				if(g_knife3[id])                                                                                                
					emit_sound(id, channel, Knife3_sound[1], volume, attn, flags, pitch)
				if(g_knife4[id])                                                                
					emit_sound(id, channel, Knife4_sound[1], volume, attn, flags, pitch)                        
				if(g_knife5[id])
					emit_sound(id, channel, Knife5_sound[1], volume, attn, flags, pitch)
				if(g_knife6[id])
					emit_sound(id, channel, Knife6_sound[1], volume, attn, flags, pitch)
			}
		}
		else
		{
			if (sample[15] == 'l') 
			{                                                                                        
				if(g_knife1[id])
					emit_sound(id, channel, Knife1_sound[3], volume, attn, flags, pitch)
				if(g_knife2[id])
					emit_sound(id, channel, Knife2_sound[3], volume, attn, flags, pitch)
				if(g_knife3[id])
					emit_sound(id, channel, Knife3_sound[3], volume, attn, flags, pitch)
				if(g_knife4[id])
					emit_sound(id, channel, Knife4_sound[3], volume, attn, flags, pitch)
				if(g_knife5[id])                                                                           
					emit_sound(id, channel, Knife5_sound[3], volume, attn, flags, pitch) 
				if(g_knife6[id])
					emit_sound(id, channel, Knife6_sound[3], volume, attn, flags, pitch)
			}                                                                                          
			else 
			{                                                                                    
				if(g_knife1[id])
					emit_sound(id, channel, Knife1_sound[4], volume, attn, flags, pitch)
				if(g_knife2[id])
					emit_sound(id, channel, Knife2_sound[4], volume, attn, flags, pitch)
				if(g_knife3[id])                                                                                   
					emit_sound(id, channel, Knife3_sound[4], volume, attn, flags, pitch)                
				if(g_knife4[id])
					emit_sound(id, channel, Knife4_sound[4], volume, attn, flags, pitch)
				if(g_knife5[id])
					emit_sound(id, channel, Knife5_sound[4], volume, attn, flags, pitch)
				if(g_knife6[id])
					emit_sound(id, channel, Knife6_sound[4], volume, attn, flags, pitch)
			}
		}
		return HAM_SUPERCEDE
	}
	return HAM_IGNORED
}

public start_menu(id)                                                                                     
{    
    // check if user is either zombie or if he has already used the knife menu this round                                  
	if((!zp_get_user_zombie(id)) && g_block_knife[id])
         {                                                                                         
		static menu[555], iLen            
		iLen = 0                                                                                         
		iLen = formatex(menu[iLen], charsmax(menu) - iLen, "\r[\yKnife Test\r]^n^n")          
		
		if(s_knife0[id])
		{                                                                                                              
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y1\r] [\yKnife\r] [\yTest1\r] [\wSelected\r]^n")                            
			key0 &= ~MENU_KEY_1                                                                                                   
		}
		else                                                                                                      
		{                                                                                                                  
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y1\r] [\yKnife\r] [\yTest1\r]^n")                                     
			key0 |= MENU_KEY_1 
		}
		
		if(s_knife1[id])
		{
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y2\r] [\yПротон\r] [\yСкорость\r] [\wВыбрано\r]^n")                            
			key0 &= ~MENU_KEY_2
		}                                                                                                                
		else                                                                                                                    
		{
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y2\r] [\yПротон\r] [\yСкорость\r]^n")                                        
			key0 |= MENU_KEY_2
		}                                                                                                                
		
		if(s_knife2[id])
		{
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y3\r] [\yТемная Ночь\r] [\yГравитация\r] [\wВыбрано\r]^n")                            
			key0 &= ~MENU_KEY_3
		}                                                                                                              
		else
		{
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y3\r] [\yТемная Ночь\r] [\yГравитация\r]^n")                              
			key0 |= MENU_KEY_3 
		}                                                                                                                 
		
		if(s_knife3[id])                                                                                   
		{
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y4\r] [\yЯрость Солнца\r] [\yУрон x2\r] [\wВыбрано\r]^n^n")                            
			key0 &= ~MENU_KEY_4
		}                                                                                                                 
		else
		{                                                                                                               
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y4\r] [\yЯрость Солнца\r] [\yУрон x2\r]^n^n")                                  
			key0 |= MENU_KEY_4                                                                                               
		}
		
		if(get_user_flags(id) & VIP_FLAG)                                                                                
		{                                                                                       
			if(s_knife4[id])
			{
				iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y5\r] [\yСудный день\r] [\yVIP\r] [\wВыбрано\r]^n")                            
				key0 &= ~MENU_KEY_5                                                                                      
			}                                                                                                                 
			else                                                                                                                 
			{                                                                                                                        
				iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y5\r] [\yСудный день\r] [\yVIP\r]^n")                                     
				key0 |= MENU_KEY_5                                                                                                 
			}                                                                                                                   
		}                                                                                                             
		else                                                                                                             
		{                                                                                         
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\d[5] Вы не [\rVIP\d]^n^n")                            
			key0 &= ~MENU_KEY_5                                                                                          
		}                                                                                                              
		
		if(get_user_flags(id) & ADMIN_FLAG)
		{ 
			if(s_knife5[id])
			{                                                                                                                  
				iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y6\r] [\yХамер Силы\r] [\yАдмин\r] [\wВыбрано\r]^n")                            
				key0 &= ~MENU_KEY_6
			}                                                                                                                 
			else                                                                                                                 
			{
				iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y6\r] [\yХамер Силы\r] [\yАдмин\r]^n")                            
				key0 |= MENU_KEY_6                                                                                            
			}                                                                                                                       
		}                                                                                                                     
		else
		{                                                                          
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\d[6] Вы не [\rАдмин\d]^n^n")                               
			key0 &= ~MENU_KEY_6
		}
		
		if(get_user_flags(id) & SOZDATEL_FLAG)                                                                           
		{
			if(s_knife6[id])
			{
				iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y7\r] [\yХамер Власти\r] [\yСоздатель\r] [\wВыбрано\r]^n")                            
				key0 &= ~MENU_KEY_7
			}                                                                                                                 
			else                                                                                                                 
			{                                                                             
				iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\r[\y7\r] [\yХамер Власти\r] [\yСоздатель\r]^n^n")                                  
				key0 |= MENU_KEY_7                                                                                                     
			}
		}
		else
		{                                                                                                                
			iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\d[7] Вы не [\rСоздатель\d]^n^n")
			key0 &= ~MENU_KEY_7                                                                                      
		}                                                                                                
		
		iLen += formatex(menu[iLen], charsmax(menu) - iLen, "\y[\w0\y] \rВыход")                                          
		key0 |= MENU_KEY_0                                                                    
		
		show_menu(id, key0, menu, -1, "Menu_0")    
		// after displaying the menu, we will disable the menu for that player  
		g_block_knife[id] = false                                                                      
	}                                                                                         
	else                                                          
	{
		color_print(id, "%s !gДоступ !tтолько !gчеловеку",PREFIKS)
	}
}                                                                

public Key_0(id, key)                                       
{                                                                                               
	new weaponid                                  
	weaponid = get_user_weapon(id)                                     
	switch(key)                                                          
	{                                                     
		case 0:                                                     
		{
			g_knife1[id] = false
			g_knife2[id] = false
			g_knife3[id] = false                                    
			g_knife4[id] = false                 
			g_knife5[id] = false                                     
			g_knife6[id] = false
			
			s_knife0[id] = true
			s_knife1[id] = false
			s_knife2[id] = false
			s_knife3[id] = false                                               
			s_knife4[id] = false                 
			s_knife5[id] = false                              
			s_knife6[id] = false                                             
			
			g_block[id] = true                                       
			start_menu(id)
			buy_sound(id)
			color_print(id, "%s !gВы !tвыбрали !gнож!t: [!gСтандартный!t]",PREFIKS) 
			color_print(id, "%s !gСпособности!t: [!gНету!t]",PREFIKS)
			
			if(is_user_alive(id))                             
			{
				if(weaponid == CSW_KNIFE)                                                       
				{             
					set_pev(id, pev_viewmodel2, Knife_v_0)                                                                                 
					set_pev(id, pev_weaponmodel2, Knife_p_0)
				}
			}                                                                      
		}                                                                                     
		case 1:                                                         
		{                                                                                               
			g_knife1[id] = true          
			g_knife2[id] = false
			g_knife3[id] = false
			g_knife4[id] = false                                                     
			g_knife5[id] = false
			g_knife6[id] = false
			
			s_knife0[id] = false
			s_knife1[id] = true
			s_knife2[id] = false
			s_knife3[id] = false
			s_knife4[id] = false                 
			s_knife5[id] = false                              
			s_knife6[id] = false
			
			g_block[id] = true
			start_menu(id)                                                               
			buy_sound(id)
			color_print(id, "%s !gВы !tвыбрали !gнож!t: [!gПротон!t]",PREFIKS)
			color_print(id, "%s !gСпособности!t: [!gУвеличение Скорости!t]",PREFIKS)
			
			if(is_user_alive(id))                             
			{
				if(weaponid == CSW_KNIFE)                                                       
				{             
					set_pev(id, pev_viewmodel2, Knife_v_1)                                                                                 
					set_pev(id, pev_weaponmodel2, Knife_p_1)
				}
			}
		}                                                                      
		case 2:                                                   
		{
			g_knife1[id] = false
			g_knife2[id] = true
			g_knife3[id] = false
			g_knife4[id] = false
			g_knife5[id] = false
			g_knife6[id] = false
			
			s_knife0[id] = false
			s_knife1[id] = false
			s_knife2[id] = true
			s_knife3[id] = false
			s_knife4[id] = false                 
			s_knife5[id] = false                              
			s_knife6[id] = false
			
			g_block[id] = true
			start_menu(id) 
			buy_sound(id)
			color_print(id, "%s !gВы !tвыбрали !gнож!t: [!gТемная ночь!t]",PREFIKS)
			color_print(id, "%s !gСпособности!t: [!gУменьшение Гравитации!t]",PREFIKS)
			
			if(is_user_alive(id))
			{
				if(weaponid == CSW_KNIFE) 
				{             
					set_pev(id, pev_viewmodel2, Knife_v_2)                                                                                 
					set_pev(id, pev_weaponmodel2, Knife_p_2)
				}
			}
		}                                                               
		case 3:                                                   
		{                                                        
			g_knife1[id] = false
			g_knife2[id] = false
			g_knife3[id] = true
			g_knife4[id] = false
			g_knife5[id] = false
			g_knife6[id] = false 
			
			s_knife0[id] = false
			s_knife1[id] = false
			s_knife2[id] = false
			s_knife3[id] = true
			s_knife4[id] = false                 
			s_knife5[id] = false                              
			s_knife6[id] = false
			
			g_block[id] = true
			start_menu(id)
			buy_sound(id)
			//color_print(id, "%s !gВы !tвыбрали !gнож!t: [!gЯрость Солнца!t]",PREFIKS)
			//color_print(id, "%s !gСпособности!t: [!gУдвоение Урона!t]",PREFIKS)
			
			if(is_user_alive(id))
			{
				if(weaponid == CSW_KNIFE) 
				{             
					set_pev(id, pev_viewmodel2, Knife_v_3)                                                                                 
					set_pev(id, pev_weaponmodel2, Knife_p_3)
				}
			}
		}                                
		case 4:                                                   
		{
			g_knife1[id] = false
			g_knife2[id] = false
			g_knife3[id] = false
			g_knife4[id] = true
			g_knife5[id] = false 
			g_knife6[id] = false
			
			s_knife0[id] = false
			s_knife1[id] = false
			s_knife2[id] = false
			s_knife3[id] = false
			s_knife4[id] = true                 
			s_knife5[id] = false                                                                            
			s_knife6[id] = false
			
			g_block[id] = true                                                                                                   
			start_menu(id)
			buy_sound(id)
			color_print(id, "%s !gВы !tвыбрали !gнож!t: [!gСудный день!t]",PREFIKS)
			color_print(id, "%s !gСпособности!t: [!gВсе способности + %d Прыжка!t]",PREFIKS,get_pcvar_num(gump_vip))
			
			if(is_user_alive(id))
			{
				if(weaponid == CSW_KNIFE) 
				{                                                                                                                      
					set_pev(id, pev_viewmodel2, Knife_v_4)                                                                                 
					set_pev(id, pev_weaponmodel2, Knife_p_4)
				}
			}
		}
		case 5:                                                   
		{
			g_knife1[id] = false
			g_knife2[id] = false
			g_knife3[id] = false
			g_knife4[id] = false
			g_knife5[id] = true
			g_knife6[id] = false
			
			s_knife0[id] = false
			s_knife1[id] = false
			s_knife2[id] = false
			s_knife3[id] = false
			s_knife4[id] = false                 
			s_knife5[id] = true                              
			s_knife6[id] = false
			
			g_block[id] = true
			start_menu(id)
			buy_sound(id)
		//	color_print(id, "%s !gВы !tвыбрали !gнож!t: [!gХамер Силы!t]",PREFIKS)
		//	color_print(id, "%s !gСпособности!t: [!gВсе способности + %d Прыжка!t]",PREFIKS,get_pcvar_num(gump_admin))
			
			if(is_user_alive(id))
			{
				if(weaponid == CSW_KNIFE) 
				{             
					set_pev(id, pev_viewmodel2, Knife_v_5)                                                                                 
					set_pev(id, pev_weaponmodel2, Knife_p_5)
				}
			}
		}
		case 6:                                                   
		{                             
			g_knife1[id] = false
			g_knife2[id] = false
			g_knife3[id] = false
			g_knife4[id] = false
			g_knife5[id] = false
			g_knife6[id] = true
			
			s_knife0[id] = false
			s_knife1[id] = false
			s_knife2[id] = false
			s_knife3[id] = false
			s_knife4[id] = false                 
			s_knife5[id] = false                                                                                                    
			s_knife6[id] = true 
			
			g_block[id] = true
			start_menu(id)
			buy_sound(id)
		//	color_print(id, "%s !gВы !tвыбрали !gнож!t: [!gХамер Власти!t]",PREFIKS)
			//color_print(id, "%s !gСпособности!t: [!gВсе способности + %d Прыжка!t]",PREFIKS,get_pcvar_num(gump_sozdatel))
			
			if(is_user_alive(id))                                                  
			{
				if(weaponid == CSW_KNIFE)                                                           
				{                                                                                             
					set_pev(id, pev_viewmodel2, Knife_v_6)                                                                                 
					set_pev(id, pev_weaponmodel2, Knife_p_6)
				}                                                                                  
			}
		}
	}
	return PLUGIN_HANDLED                                                                                         
}

public buy_sound(id)
{                                                                                                       
	emit_sound(id, CHAN_BODY, Buy_Sound, 1.0, ATTN_NORM, 0, PITCH_NORM)                                
}                           

public client_PreThink(id)
{
	if(!zp_get_user_zombie(id))                                                                               
	{
		if(!is_user_alive(id)) return PLUGIN_CONTINUE                                                                        
		new nbut = get_user_button(id)
		new obut = get_user_oldbutton(id)                                                                          
		if((nbut & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND) && !(obut & IN_JUMP))                          
		{                                                                                                       
			if(jumpnum[id] < g_jump[id])                                                                          
			{                         
				dojump[id] = true                                                  
				jumpnum[id]++                                                                                        
				//jump_line(id) // removed
				return PLUGIN_CONTINUE                                 
			}                                                                   
		}                                                                             
		if((nbut & IN_JUMP) && (get_entity_flags(id) & FL_ONGROUND))
		{                                                                        
			jumpnum[id] = 0
			return PLUGIN_CONTINUE
		} 
	}
	return PLUGIN_CONTINUE
}

public client_PostThink(id)
{
	if(!zp_get_user_zombie(id))                           
	{
		if(!is_user_alive(id)) return PLUGIN_CONTINUE
		if(dojump[id] == true)                                     
		{
			new Float:velocity[3]                                       
			entity_get_vector(id,EV_VEC_velocity,velocity)                  
			velocity[2] = random_float(265.0,285.0)                                  
			entity_set_vector(id,EV_VEC_velocity,velocity)
			dojump[id] = false
			return PLUGIN_CONTINUE                         
		}                                                                   
	}
	return PLUGIN_CONTINUE
}

public next_sp(id)
{
	if(g_knife6[id])
	{
		if(g_sp[id])
		{
			g_sp[id] = false
		}                                                                 
		else
		{                                                       
			g_sp[id] = true
		}
	}
}

public CTask__BurningFlame(taskid)
{                                                          
	static origin[3], flags     
	get_user_origin(ID_FBURN, origin)
	flags = pev(ID_FBURN, pev_flags)                   
	
	if((flags & FL_INWATER) || g_burning_duration[ID_FBURN] < 1 || g_fRoundEnd || !is_user_alive(ID_FBURN))
	{
		message_begin(MSG_PVS, SVC_TEMPENTITY, origin)
		write_byte(TE_SMOKE) // TE id  
		write_coord(origin[0]) // x
		write_coord(origin[1]) // y                                           
		write_coord(origin[2]-50) // z
		write_short(g_smokeSpr) // sprite
		write_byte(random_num(15, 20)) // scale
		write_byte(random_num(10, 20)) // framerate
		message_end()                                   
		
		remove_task(taskid)                                                         
		return
	}
	
	static health                                                    
	health = pev(ID_FBURN, pev_health)                                                                    
	
	if (health - get_pcvar_num(g_fire_damage) > 0)                           
		set_user_health(ID_FBURN, health - get_pcvar_num(g_fire_damage))          
	
	// Flame sprite
	message_begin(MSG_PVS, SVC_TEMPENTITY, origin)                             
	write_byte(TE_SPRITE) // TE id
	write_coord(origin[0]+random_num(-5, 5)) // x                                 
	write_coord(origin[1]+random_num(-5, 5)) // y
	write_coord(origin[2]+random_num(-10, 10)) // z
	write_short(g_flameSpr) // sprite
	write_byte(random_num(5, 10)) // scale                
	write_byte(200) // brightness                                                 
	message_end()
	
	g_burning_duration[ID_FBURN]--
}

stock create_velocity_vector(victim,attacker,Float:velocity[3])
{
	if(!zp_get_user_zombie(victim) || !is_user_alive(attacker))
		return 0;
	
	new Float:vicorigin[3];
	new Float:attorigin[3];
	pev(victim, pev_origin , vicorigin);
	pev(attacker, pev_origin , attorigin);
	
	new Float:origin2[3]
	origin2[0] = vicorigin[0] - attorigin[0];
	origin2[1] = vicorigin[1] - attorigin[1];
	
	new Float:largestnum = 0.0;
	
	if(floatabs(origin2[0])>largestnum) largestnum = floatabs(origin2[0]);
	if(floatabs(origin2[1])>largestnum) largestnum = floatabs(origin2[1]);
	
	origin2[0] /= largestnum;
	origin2[1] /= largestnum;
	
	if (g_knife1[attacker])
	{
		velocity[0] = ( origin2[0] * get_pcvar_float(knock_knife1) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
		velocity[1] = ( origin2[1] * get_pcvar_float(knock_knife1) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
	}
	else if (g_knife2[attacker])
	{
		velocity[0] = ( origin2[0] * get_pcvar_float(knock_knife2) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
		velocity[1] = ( origin2[1] * get_pcvar_float(knock_knife2) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
	}
	else if (g_knife3[attacker])
	{
		velocity[0] = ( origin2[0] * get_pcvar_float(knock_knife3) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
		velocity[1] = ( origin2[1] * get_pcvar_float(knock_knife3) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
	}
	else if (g_knife4[attacker])
	{
		velocity[0] = ( origin2[0] * get_pcvar_float(knock_knife4) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
		velocity[1] = ( origin2[1] * get_pcvar_float(knock_knife4) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
	}
	else if (g_knife5[attacker])
	{
		velocity[0] = ( origin2[0] * get_pcvar_float(knock_knife5) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
		velocity[1] = ( origin2[1] * get_pcvar_float(knock_knife5) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
	}
	/* else if(g_has_survivoraxe[attacker])
{
	velocity[0] = ( origin2[0] * get_pcvar_float(cvar_knock_surv) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
	velocity[1] = ( origin2[1] * get_pcvar_float(cvar_knock_surv) * 10000 ) / floatround(get_distance_f(vicorigin, attorigin));
} */

if(velocity[0] <= 20.0 || velocity[1] <= 20.0)
	velocity[2] = random_float(200.0 , 275.0);
	
	return 1;
}

stock color_print(const id, const input[], any:...)                                           
{                                                         
	new count = 1, players[32];                                            
	static msg[191];                                                             
	vformat(msg, 190, input, 3);                          
	
	replace_all(msg, 190, "!g", "^x04"); // Green Color                           
	replace_all(msg, 190, "!n", "^x01"); // Default Color                           
	replace_all(msg, 190, "!t", "^x03"); // Team Color                           
	
	if (id) players[0] = id; else get_players(players, count, "ch");
{
	for (new i = 0; i < count; i++)                                               
	{                                                
		if (is_user_connected(players[i]))
		{                                           
			message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i]) 
			write_byte(players[i]);    
			write_string(msg);                                           
			message_end();
		}
	}
}
}

