#include amxmodx
#include fakemeta
#include hamsandwich
#include nvault
#include zombieplague

#if AMXX_VERSION_NUM > 182
#define client_disconnect client_disconnected
#endif


new
g_iUserClass[33],
g_iUserNextClass[33],
g_iMenuPosition[33],

Array:aClassName,
Array:aClassFlags,
Array:aClassPrivilege,
Array:aClassModel,
Array:aClassSubModel,
Array:aClassModelIndex,
Array:aClassHealth,
Array:aClassArmor,

g_iNvault;

public plugin_init() {

	register_plugin("[ZP Addon] Human Classes", "0.1", "ONYX");

	register_menucmd(register_menuid("Show_ClassesMenu"), (1<<0|1<<1|1<<2|1<<3|1<<4|1<<5|1<<6|1<<7|1<<8|1<<9), "Handler_ClassesMenu");
	register_clcmd("class", "Open_ClassesMenu");
	register_clcmd("say /hc", "Open_ClassesMenu");
	
	RegisterHam(Ham_Spawn, "player", "Ham_PlayerSpawnPost", true);
	g_iNvault = nvault_open("models_model");

}

public plugin_natives() register_native("HC_GetUserClassName", "native_HC_GetUserClassName", 0);
public plugin_precache() {

	aClassName 			= ArrayCreate(32);
	aClassFlags 		= ArrayCreate(10);
	aClassPrivilege 	= ArrayCreate(32);
	aClassModel 		= ArrayCreate(64);
	aClassSubModel 		= ArrayCreate();
	aClassModelIndex 	= ArrayCreate();
	aClassHealth 		= ArrayCreate();
	aClassArmor 		= ArrayCreate();

	//new pFile = fopen("addons/amxmodx/configs/models_model.ini", "rt");
	new pFile = fopen("addons/amxmodx/configs/sG_Human_Class.ini", "rt")
	if(!pFile) set_fail_state("[Human classes] No classes load. Check you human.classes.ini");
	
	while(!feof(pFile)) {
		
		new szLine[512], szKey[64], szValue[440]; fgets(pFile, szLine, charsmax(szLine));
		replace(szLine, charsmax(szLine), "^n", "");
		
		if(!equal(szLine, "") && szLine[0] != ';' && szLine[0] != '[') {
			
			strtok(szLine, szKey, charsmax(szKey), szValue, charsmax(szValue), '=');
			trim(szKey); trim(szValue);
			
			if(equal(szKey, "NAME")) ArrayPushString(aClassName, szValue);
			else if(equal(szKey, "FLAGS")) ArrayPushString(aClassFlags, szValue);
			else if(equal(szKey, "PRIVILEGE")) ArrayPushString(aClassPrivilege, szValue);
			else if(equal(szKey, "HEALTH")) ArrayPushCell(aClassHealth, str_to_float(szValue));
			else if(equal(szKey, "ARMOR")) ArrayPushCell(aClassArmor, str_to_float(szValue));
			else if(equal(szKey, "SUB MODEL")) ArrayPushCell(aClassSubModel, str_to_num(szValue));
			else if(equal(szKey, "MODEL")) {
		
			
		                                          
			
				new szModel[64];
				formatex(szModel, charsmax(szModel), "models/player/%s/%s.mdl", szValue, szValue);
			
				ArrayPushString(aClassModel, szValue);
				ArrayPushCell(aClassModelIndex, engfunc(EngFunc_PrecacheModel, szModel));
				
			}

		}
		
	}
	
	if(!ArraySize(aClassName)) set_fail_state("[HClass] No classes load. Check you models_model.ini");
	fclose(pFile);

}

public Open_ClassesMenu(iPlayer) return Show_ClassesMenu(iPlayer, g_iMenuPosition[iPlayer] = 0);
Show_ClassesMenu(iPlayer, iPosition) {

	if(iPosition < 0) return PLUGIN_HANDLED;
	
	new iStart = iPosition * 8, iClassesCount = ArraySize(aClassName);
	if(iStart > iClassesCount) iStart = iClassesCount;
	iStart = iStart - (iStart % 8);
	
	g_iMenuPosition[iPlayer] = iStart / 8;
	new iEnd = iStart + 8;
	if(iEnd > iClassesCount) iEnd = iClassesCount;
	
	new szMenu[1024], iLen;
	iLen = formatex(szMenu, charsmax(szMenu), "\yHuman Class:^n^n");
	
	new iKeys = (1<<9), b;
	new szName[128], szFlags[10], bool:bFlagsAccess, szPrivilege[32];
	
	for(new a = iStart; a < iEnd; a++) {
		
		ArrayGetString(aClassName, a, szName, charsmax(szName));
		
		ArrayGetString(aClassFlags, a, szFlags, charsmax(szFlags));
		
		bFlagsAccess = ((get_user_flags(iPlayer) & read_flags(szFlags)) || equal(szFlags, "z")) ? true : false;
		
		if(!bFlagsAccess) {
			
			ArrayGetString(aClassPrivilege, a, szPrivilege, charsmax(szPrivilege));
			format(szName, charsmax(szName), "%s \r[%s]", szName, szPrivilege);
			
		}
		
		if(bFlagsAccess) {
		
			iKeys |= (1<<b);
			
			if(a != g_iUserClass[iPlayer]) iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%s \w%s^n", UTIL_MenuButton(++b), szName);
			else iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%s \d%s \ySelected^n", UTIL_MenuButton(++b), szName);
		
		} else iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "%s \d%s^n", UTIL_MenuButton(++b), szName);
		
	}
	
	for(new i = b; i < 8; i++) iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n");
	if(iEnd < iClassesCount) {
	
		iKeys |= (1<<8);
		formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n%s \wВперед^n%s \w%s", UTIL_MenuButton(9), UTIL_MenuButton(0), iPosition ? "Back" : "Next");
		
	} else formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n^n%s \w%s", UTIL_MenuButton(0), iPosition ? "Назад" : "Выход");
	return show_menu(iPlayer, iKeys, szMenu, -1, "Show_ClassesMenu");

}

public Handler_ClassesMenu(iPlayer, iKey) {

	switch(iKey) {
	
		case 8: return Show_ClassesMenu(iPlayer, ++g_iMenuPosition[iPlayer]);
		case 9: return Show_ClassesMenu(iPlayer, --g_iMenuPosition[iPlayer]);
		default: SwitchModel(iPlayer, g_iMenuPosition[iPlayer] * 8 + iKey);
		
	}
	return PLUGIN_HANDLED;

}

public Ham_PlayerSpawnPost(iPlayer) {

	if(!zp_get_user_zombie(iPlayer) && !zp_get_user_survivor(iPlayer)) {
	
		if(g_iUserClass[iPlayer] != g_iUserNextClass[iPlayer]) UTIL_SayText(iPlayer, "!gsG | !yThe Model has changed.");
		ChangeModel(iPlayer, g_iUserClass[iPlayer] = g_iUserNextClass[iPlayer]);
		
		static Float:flHealth;
		flHealth = ArrayGetCell(aClassHealth, g_iUserClass[iPlayer]);
		
		//static Float:flArmor;
	//	flArmor = ArrayGetCell(aClassArmor, g_iUserClass[iPlayer]);
		
		set_pev(iPlayer, pev_health, flHealth);
		//set_pev(iPlayer, pev_armorvalue, flArmor);
	
	}

}

public zp_user_humanized_post(iPlayer, iSurvivor) if(!iSurvivor) ChangeModel(iPlayer, g_iUserClass[iPlayer]);
public native_HC_GetUserClassName(iPluginID, Params[]) {

	new szClass[32]; ArrayGetString(aClassName, g_iUserClass[get_param(1)], szClass, charsmax(szClass));
	set_string(2, szClass, charsmax(szClass));

}

public plugin_end() nvault_close(g_iNvault);
public client_putinserver(iPlayer) LoadClass(iPlayer);
public client_disconnect(iPlayer) SaveClass(iPlayer);

SwitchModel(iPlayer, iModel) {

	if(g_iUserClass[iPlayer] != iModel) {
	
		new szName[32];
		ArrayGetString(aClassName, iModel, szName, charsmax(szName));
	
		g_iUserNextClass[iPlayer] = iModel;
		UTIL_SayText(iPlayer, "!gsG | !ySelected human class: !t%s!y. Change the class in the next round.", szName);
	
	}

}

ChangeModel(iPlayer, iModel) {
	
	new szModel[64];
	ArrayGetString(aClassModel, iModel, szModel, charsmax(szModel));
	
	zp_override_user_model(iPlayer, szModel, ArrayGetCell(aClassModelIndex, iModel));
	set_pev(iPlayer, pev_body, ArrayGetCell(aClassSubModel, iModel));

}

LoadClass(iPlayer) {

	new szAuthID[32]; get_user_authid(iPlayer, szAuthID, charsmax(szAuthID));
	new iClass = nvault_get(g_iNvault, szAuthID);
	
	new szFlags[10];
	
	ArrayGetString(aClassFlags, iClass, szFlags, charsmax(szFlags));
	
	new bool:bFlagsAccess = ((get_user_flags(iPlayer) & read_flags(szFlags)) || equal(szFlags, "z")) ? true : false;

	if(bFlagsAccess) iClass = iClass;
	else iClass = 0;	
	
	g_iUserClass[iPlayer] = g_iUserNextClass[iPlayer] = iClass;
	ChangeModel(iPlayer, iClass);


}

SaveClass(iPlayer) {

	new szAuthID[32];
	get_user_authid(iPlayer, szAuthID, charsmax(szAuthID));
	
	new szData[3]; num_to_str(g_iUserClass[iPlayer], szData, charsmax(szData));
	nvault_set(g_iNvault, szAuthID, szData);

}

stock UTIL_SayText(pPlayer, const szMessage[], any:...) {

	new szBuffer[190];
	
	if(numargs() > 2) vformat(szBuffer, charsmax(szBuffer), szMessage, 3);
	else copy(szBuffer, charsmax(szBuffer), szMessage);
	
	while(replace(szBuffer, charsmax(szBuffer), "!y", "^1")) {}
	while(replace(szBuffer, charsmax(szBuffer), "!t", "^3")) {}
	while(replace(szBuffer, charsmax(szBuffer), "!g", "^4")) {}
	
	switch(pPlayer) {
	
		case 0: {
		
			for(new iPlayer = 1; iPlayer <= get_maxplayers(); iPlayer++) {
			
				if(!is_user_connected(iPlayer)) continue;
				engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, 76, {0.0, 0.0, 0.0}, iPlayer);
				write_byte(iPlayer);
				write_string(szBuffer);
				message_end();
				
				
			}
			
		}
		default: {
		
			engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, 76, {0.0, 0.0, 0.0}, pPlayer);
			write_byte(pPlayer);
			write_string(szBuffer);
			message_end();
			
		}
		
	}
	
}

stock UTIL_MenuButton(iNumber = -1) {

	new szButton[16];
	if(iNumber == -1) formatex(szButton, charsmax(szButton), "\r[\y#\r]");
	else formatex(szButton, charsmax(szButton), "\r[\y%d\r]", iNumber);
	
	return szButton;

}
