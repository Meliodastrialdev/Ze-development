#include <amxmodx>
#include <fakemeta>
#include <fun> 
#include <engine> 
#include <hamsandwich>
#include <zombieplague>
#include <fakemeta_util>

#define PLUGIN    "Choose class"
#define VERSION    "милион какая та"
#define AUTHOR    "Bez автора хули"

new g_class1[33] 
new g_class2[33] 
new g_class3[33] 
new g_class4[33]
new g_class5[33]
new g_class6[33] 

#define FEMALE		"hcfemale"
#define MALE		"hcmale"
#define ONE			"0" // David Black | Choi Ji Yoon Limited
#define TWO			"1" // Asia Red Army | Alice Limited
#define FOUR		"3" // Gerrard | Yuri Limited

public plugin_init()
{
	register_plugin(PLUGIN , VERSION , AUTHOR);
	register_cvar("zp_class_human", VERSION, FCVAR_SERVER);
	RegisterHam(Ham_Spawn, "player", "Spawn_post", 1)
	register_clcmd("classmenu","class_menu",ADMIN_ALL,"class_menu")
	register_clcmd("say /hc", "class_menu")
	//register_forward(FM_PlayerPreThink, "fw_PlayerPreThink");
	
	//cvar_class1_jump= register_cvar("zp_class1_jump", "300.0");
	//cvar_class1_spd = register_cvar("zp_class1_spd", "240.0");
	//cvar_class1_dmg = register_cvar("zp_class1_dmg" , "1.0");
	
	//cvar_class2_jump= register_cvar("zp_class2_jump", "240.0");
	//cvar_class2_spd = register_cvar("zp_class2_spd", "300.0");
	//cvar_class2_dmg = register_cvar("zp_class2_dmg" , "1.0");
	
	//cvar_class3_jump= register_cvar("zp_class3_jump", "240.0");
	//cvar_class3_spd = register_cvar("zp_class3_spd", "240.0");
	//cvar_class3_dmg = register_cvar("zp_class3_dmg" , "1.7");
	
	//cvar_class4_jump= register_cvar("zp_class4_jump", "310.0");
	//cvar_class4_spd = register_cvar("zp_class4_spd", "310.0");
	//cvar_class4_dmg = register_cvar("zp_class4_dmg" , "1.7");
		
	//cvar_class5_jump= register_cvar("zp_class5_jump", "340.0");
	//cvar_class5_spd = register_cvar("zp_class5_spd", "350.0");
	//cvar_class5_dmg = register_cvar("zp_class5_dmg" , "2.0");
	
	//cvar_class6_jump= register_cvar("zp_class6_jump", "360.0");
	//cvar_class6_spd = register_cvar("zp_class6_spd", "370.0");
	//cvar_class6_dmg = register_cvar("zp_class6_dmg" , "2.5");
}

public human_menu(id)
{
	new menu = menu_create("\ysG | Human Class", "menu_handler");
	menu_additem(menu, "\r[\yМ\r] \wDavid Black \r[\yГрав+\r]", "1", 0);
	menu_additem(menu, "\r[\yМ\r] \wAsia Red Army \r[\yСк+\r]", "2", 0);
	menu_additem(menu, "\r[\yМ\r] \wGerrard \r[\yУр+\r]^n", "3", 0);
	
	menu_additem(menu, "\r[\yЖ\r] \wChoi Ji Yoon Limited\r[\yВсе+\r]", "4", 0);
	menu_additem(menu, "\r[\yЖ\r] \wAlice Limited\r[\yВсе++\r]", "5", 0);
	menu_additem(menu, "\r[\yЖ\r] \wYuri Limited\r[\yВсе+++\r]", "6", 0);

	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
    
	menu_display(id, menu, 0);    
} 


public plugin_precache()
{
	new model[66]
	
	format(model, charsmax(model), "models/player/hcfemale/hcfemale.mdl")
	engfunc(EngFunc_PrecacheModel, model)
	format(model, charsmax(model), "models/player/hcmale/hcmale.mdl")
	engfunc(EngFunc_PrecacheModel, model);
}

/*public fw_PlayerPreThink(id)
{
	if(!is_user_alive(id) || zp_get_user_zombie(id))
	return FMRES_IGNORED

	if (g_class1[id])
	{
		set_pev(id, pev_maxspeed, get_pcvar_float(cvar_class1_spd))

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
			
			fVelocity[2] += get_pcvar_num(cvar_class1_jump)
			
			set_pev(id, pev_velocity, fVelocity)
			set_pev(id, pev_gaitsequence, 6)
		}
	}
	
	if (g_class2[id])
	{
		set_pev(id, pev_maxspeed, get_pcvar_float(cvar_class2_spd))

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
			
			fVelocity[2] += get_pcvar_num(cvar_class2_jump)
			
			set_pev(id, pev_velocity, fVelocity)
			set_pev(id, pev_gaitsequence, 6)
		}
	}
	
	if (g_class3[id])
	{
		set_pev(id, pev_maxspeed, get_pcvar_float(cvar_class3_spd))

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
			
			fVelocity[2] += get_pcvar_num(cvar_class3_jump)
			
			set_pev(id, pev_velocity, fVelocity)
			set_pev(id, pev_gaitsequence, 6)
		}
	}
	
	if (g_class4[id])
	{
		set_pev(id, pev_maxspeed, get_pcvar_float(cvar_class4_spd))

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
			
			fVelocity[2] += get_pcvar_num(cvar_class4_jump)
			
			set_pev(id, pev_velocity, fVelocity)
			set_pev(id, pev_gaitsequence, 6)
		}
	}
	
	if (g_class5[id])
	{
		set_pev(id, pev_maxspeed, get_pcvar_float(cvar_class5_spd))

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
			
			fVelocity[2] += get_pcvar_num(cvar_class5_jump)
			
			set_pev(id, pev_velocity, fVelocity)
			set_pev(id, pev_gaitsequence, 6)
		}
	}
	
	if (g_class6[id])
	{
		set_pev(id, pev_maxspeed, get_pcvar_float(cvar_class6_spd))

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
			
			fVelocity[2] += get_pcvar_num(cvar_class6_jump)
			
			set_pev(id, pev_velocity, fVelocity)
			set_pev(id, pev_gaitsequence, 6)
		}
	}
	return FMRES_IGNORED
} */ 

/*public fw_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	if(!is_user_connected(attacker))
		return HAM_IGNORED
	
	if(zp_get_user_zombie(attacker))
		return HAM_IGNORED
	
	if (g_class1[attacker])
	{	
		SetHamParamFloat(4, damage * get_pcvar_float(cvar_class1_dmg))
	}
	
	if (g_class2[attacker])
	{	
		SetHamParamFloat(4, damage * get_pcvar_float(cvar_class2_dmg))
	}
	
	if (g_class3[attacker])
	{	
		SetHamParamFloat(4, damage * get_pcvar_float(cvar_class3_dmg))
	}
	
	if (g_class4[attacker])
	{	
		SetHamParamFloat(4, damage * get_pcvar_float(cvar_class4_dmg))
	}
	
	if (g_class5[attacker])
	{	
		SetHamParamFloat(4, damage * get_pcvar_float(cvar_class5_dmg))
	}
		
	if (g_class6[attacker])
	{	
		SetHamParamFloat(4, damage * get_pcvar_float(cvar_class6_dmg))
	}
	return HAM_IGNORED
}*/



public client_connect(id)
{
g_class1[id] = false
g_class2[id] = false
g_class3[id] = false
g_class4[id] = false
g_class5[id] = false
g_class6[id] = false
}

public client_disconnected(id)
{
g_class1[id] = false
g_class2[id] = false
g_class3[id] = false
g_class4[id] = false
g_class5[id] = false
g_class6[id] = false
}

public zp_user_humanized_post(id)
{
check(id)
}

check(id)
{
	if (zp_get_user_zombie(id))
		return PLUGIN_HANDLED
    
	if (g_class1[id])
	{
	zp_override_user_model(id, MALE)
	set_pev(id, pev_body, ONE);
	}

	if (g_class2[id])
	{
	zp_override_user_model(id, MALE)
	set_pev(id, pev_body, TWO);
	}

	if (g_class3[id])
	{
	zp_override_user_model(id, MALE)
	set_pev(id, pev_body, FOUR);
	}

	if (g_class4[id])
	{
	zp_override_user_model(id, FEMALE)
	set_pev(id, pev_body, ONE);
	}
	
	if (g_class5[id])
	{
	zp_override_user_model(id, FEMALE)
	set_pev(id, pev_body, TWO);
	}

	if (g_class6[id])
	{
	zp_override_user_model(id, FEMALE)
	set_pev(id, pev_body, FOUR);
	}

	return PLUGIN_HANDLED		
}


public Spawn_post(id)
{
check(id)
}

public class_menu(id)
{

	if(is_user_alive(id) && !zp_get_user_zombie(id))
	{
		human_menu(id)
	}

	return PLUGIN_HANDLED
}


public menu_handler(id, menu, item)
{
	if( item == MENU_EXIT )
	{
       		menu_destroy(menu);
        	return PLUGIN_HANDLED;    
	}
    
	new data[6], iName[64];
	new access, callback;
    
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
    
	new key = str_to_num(data);
    
	switch(key)
	{
        case 1:
        {
			give_class1(id)
			menu_destroy(menu);
			return PLUGIN_HANDLED
		}
		case 2:
		{
			give_class2(id)
			menu_destroy(menu);
			return PLUGIN_HANDLED
		}
		case 3:
		{
			give_class3(id)
			menu_destroy(menu);
			return PLUGIN_HANDLED
		}
		case 4:
		{
			give_class4(id)
			menu_destroy(menu);
			return PLUGIN_HANDLED
		}
		case 5:
		{
			give_class5(id)
			menu_destroy(menu);
			return PLUGIN_HANDLED
		}
		case 6:
		{
			give_class6(id)
			menu_destroy(menu);
			return PLUGIN_HANDLED
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED
}

public give_class1(id)
{
	g_class1[id] = true	
	g_class2[id] = false
	g_class3[id] = false	
	g_class4[id] = false	
	g_class5[id] = false	
	g_class6[id] = false
	
	check(id);
}

public give_class2(id)
{
	g_class1[id] = false
	g_class2[id] = true
	g_class3[id] = false	
	g_class4[id] = false	
	g_class5[id] = false	
	g_class6[id] = false
	
	check(id)
}

public give_class3(id)
{
	g_class1[id] = false
	g_class2[id] = false
	g_class3[id] = true	
	g_class4[id] = false
	g_class5[id] = false	
	g_class6[id] = false

	check(id)	

}

public give_class4(id)
{
	g_class1[id] = false	
	g_class2[id] = false
	g_class3[id] = false	
	g_class4[id] = true	
	g_class5[id] = false	
	g_class6[id] = false
	
	check(id)

}

public give_class5(id)
{
	g_class1[id] = false
	g_class2[id] = false
	g_class3[id] = false
	g_class4[id] = false
	g_class5[id] = true	
	g_class6[id] = false

	check(id)	

}

public give_class6(id)
{
	g_class1[id] = false	
	g_class2[id] = false
	g_class3[id] = false	
	g_class4[id] = false
	g_class5[id] = false	
	g_class6[id] = true
	
	check(id)

}


public client_putinserver(id)
{
	switch(random_num(0, 0))
	{
		case 0:
		{
			g_class1[id] = false
		}

	}
}
