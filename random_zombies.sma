#include <amxmodx>
#include <zp50_gamemodes>

new cvar_zombiecount;
new g_MaxPlayers;

public plugin_init()
{
	register_plugin("zp random zombies", "0.1", "silentgamerz")
	
	g_MaxPlayers = get_maxplayers()
	
	register_clcmd("amx_createrandomzm", "create_zombies", ADMIN_KICK, "")
	cvar_zombiecount = register_cvar("zp_convert_zombie_count", "1")
}

public create_zombies()
{
	static iMaxHumans; 
	iMaxHumans = zp_core_get_human_count()
	if (iMaxHumans < (get_pcvar_num(cvar_zombiecount) + 1)) return;
	
	if (zp_gamemodes_get_current() == ZP_NO_GAME_MODE) return;
	
	new iZombies, id, alive_count = GetAliveCount()
	new iMaxZombies  = get_pcvar_num(cvar_zombiecount)
	iZombies = 0
	
	// Randomly turn iMaxZombies players into zombies
	while (iZombies < iMaxZombies)
	{
		// Choose random guy
		id = GetRandomAlive(random_num(1, alive_count))
		
		// Dead or already a zombie
		if (!is_user_alive(id) || zp_core_is_zombie(id))
			continue;
		
		// Turn into a zombie
		zp_core_infect(id, 0)
		iZombies++
	}
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

// Get Random Alive -returns index of alive player number target_index -
GetRandomAlive(target_index)
{
	new iAlive, id
	
	for (id = 1; id <= g_MaxPlayers; id++)
	{
		if (is_user_alive(id))
			iAlive++
		
		if (iAlive == target_index)
			return id;
	}
	
	return -1;
}
