/* LICENSE: https://github.com/Kalendarky/Licenses/blob/master/v1/README.md */

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>
#include <cstrike>
#include <hamsandwich>
#include <colorchat>
#include <engine>

#define PLUGIN	"Kalendarky"
#define AUTHOR	"VIP Plugin"
#define VERSION	"1.0"

new bool:Pouzite[33];

new bool:KNIFE[33];

new bool:C4Check[33];

new bool:SKINY[33];

new bool:SKINSID[5][33];

new evip_m4[] = "models/evip/v_m4.mdl"

new evip_ak47[] = "models/evip/v_ak47.mdl"

new evip_awp[] = "models/evip/v_awp.mdl"

new evip_deagle[] = "models/evip/v_deagle.mdl"

new evip_knife[] = "models/evip/v_knife.mdl"


public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_clcmd("say /vmenu","vmenu"); 
	register_clcmd("say_team /vmenu","vmenu");
	register_clcmd("say /skiny","skiny_zapnut"); 
	register_clcmd("say_team /skiny","skiny_zapnut");
	register_clcmd("say /rs","reset_score"); 
	register_clcmd("say_team /rs","reset_score"); 
	register_clcmd("say /RS","reset_score"); 
	register_clcmd("say_team /RS","reset_score"); 
	register_clcmd("say /rS","reset_score"); 
	register_clcmd("say_team /rS","reset_score"); 
	register_clcmd("say /Rs","reset_score"); 
	register_clcmd("say_team /Rs","reset_score"); 
	
	register_logevent("round_start", 2, "0=World triggered", "1=Round_Start");
	register_event("CurWeapon","CurWeapon","be","1=1");
}
public plugin_precache()
{
	precache_model(evip_m4);
	precache_model(evip_ak47);
	precache_model(evip_awp);
	precache_model(evip_knife);
	precache_model(evip_deagle);
}
public reset_score(id)
{
	cs_set_user_deaths(id, 0)
	set_user_frags(id, 0)
	cs_set_user_deaths(id, 0)
	set_user_frags(id, 0)
	
	new name[33]
	get_user_name(id, name, 32)
	ColorChat( 0, GREEN, "^1[^4Portal.cz^1] ^3Hrac %s si resetoval skore.",name);
	
	return PLUGIN_HANDLED;
}
public client_connect(id) {
	new name[32]
	get_user_name(id, name, charsmax(name))
	if(get_user_flags(id) & ADMIN_LEVEL_H) {
		ColorChat( 0, GREEN, "^1[^4Portal.cz^1] ^4VIP Hrac:^4 %s ^3sa ^4Pripojil do hry!", name);
	}
	else if(get_user_flags(id) & ADMIN_LEVEL_G) {
		ColorChat( 0, GREEN, "^1[^4Portal.cz^1] ^4EVIP Hrac:^4 %s ^3sa ^4Pripojil do hry!", name);
	}
}
public client_disconnect(id) {
	new name[32]
	get_user_name(id, name, charsmax(name))
	
	SKINSID[4][id] = false;
	KNIFE[id] = false;	
	SKINSID[2][id] = false;
	SKINSID[1][id] = false;
	SKINSID[3][id] = false;
	SKINY[id] = false;
	
	if(get_user_flags(id) & ADMIN_LEVEL_H) {
		ColorChat( 0, GREEN, "^1[^4Portal.cz^1] ^4VIP Hrac:^4 %s ^3sa ^4Odpojil z hry!", name);
	}
	else if(get_user_flags(id) & ADMIN_LEVEL_G) {
		ColorChat( 0, GREEN, "^1[^4Portal.cz^1] ^4EVIP Hrac:^4 %s ^3sa ^4Odpojil z hry!", name);
	}
}
public round_start(id) {
	vmenu(id)
	Pouzite[id] = false;
}
public CurWeapon(id, entity)
{
	{
		if( !is_user_connected( id ) )
		{ 
			return PLUGIN_HANDLED; 
		}
		new weaponid = get_user_weapon( id );
		switch( weaponid )
		{
			case CSW_M4A1:
			{
				if( SKINSID[1][id] == true)
				{
					set_pev(id, pev_viewmodel2, evip_m4)
				}
			}
			case CSW_AK47:
			{
				if( SKINSID[2][id] == true )
				{
					set_pev(id, pev_viewmodel2, evip_ak47)
				}
			}
			case CSW_AWP:
			{
				if( SKINSID[3][id] == true)
				{
					set_pev(id, pev_viewmodel2, evip_awp)
				}
			}
			case CSW_KNIFE:
			{
				if( KNIFE[id] == true )
				{
					set_pev( id, pev_viewmodel2, evip_knife );
				}
			}
			case CSW_DEAGLE:
			{
				if( SKINSID[4][id] == true)
				{
					set_pev( id, pev_viewmodel2, evip_deagle );
				}
			}
		} 
		return PLUGIN_CONTINUE; 
	}
}
public vmenu(id)
{
	new menus = menu_create("\yVIP \rMenu \y/\rvmenu \w(\rPortal.\yCZ\w)","vmenu_handle")
	menu_additem(menus,"\r[\yVIP\r] \w M4A1 + Deagle")
	menu_additem(menus,"\r[\yVIP\r] \w AK47 + Deagle")
	menu_additem(menus,"\r[\yVIP\r] \w FAMAS + Deagle")
	menu_additem(menus,"\r[\yEVIP\r] \w AWP + Deagle")
	menu_additem(menus,"\r[\yEVIP\r] \w Gulomet + Deagle^n\d------------Server Sekcia:------------")
	menu_additem(menus,"\rPravidla Serveru")
	
	
	
	menu_setprop(menus, MPROP_NEXTNAME, "Dalsie")
	menu_setprop(menus, MPROP_BACKNAME, "Spet")
	menu_setprop(menus, MPROP_EXITNAME, "Zavriet")
	menu_display(id,menus)
	return PLUGIN_HANDLED
}
public vmenu_handle(id,menu,item)
{
	
	if(is_user_alive(id) && is_user_connected(id) && user_has_weapon(id,CSW_C4) && get_user_team(id) == 1)
	{
		C4Check[id] = true;
	}
	else
	{
		C4Check[id] = false;
	}
	
	if(item == MENU_EXIT || !is_user_alive(id))
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	switch(item)
	{
		case 0:
		{
			if(get_user_flags(id) & ADMIN_LEVEL_H && Pouzite[id] == false)
			{
				strip_user_weapons(id)
				if(C4Check[id] == true && cs_get_user_team(id) == CS_TEAM_T)
				{
					give_item( id, "weapon_c4" );
					cs_set_user_plant(id);
				} 
				give_item(id, "weapon_m4a1")
				give_item(id, "weapon_deagle")
				give_item(id, "weapon_knife")
				give_item(id, "item_kevlar")
				cs_set_user_bpammo(id, CSW_M4A1, 90)
				cs_set_user_bpammo(id, CSW_DEAGLE, 90)
				ColorChat( id, GREEN, "^1[^4VIP^1] ^3Zobral si si M4 + deagle!!"); 
				Pouzite[id] = true;
				if(SKINY[id] == false)
				{
					SKINSID[4][id] = true;
					KNIFE[id] = true;
					SKINSID[1][id] = true;
				}
			}
			else
			{
				if(get_user_flags(id) & ADMIN_USER)
				{
					ColorChat( id, GREEN, "^1[^4VIP^1] ^3Nemas VIP!");
				}
				if(Pouzite[id] == true)
				{
					ColorChat( id, GREEN, "^1[^4VIP^1] ^3VIP menu si uz pouzil toto kolo!");
				}
			}
		}
		case 1:
		{
			if(get_user_flags(id) & ADMIN_LEVEL_H && Pouzite[id] == false)
			{
				strip_user_weapons(id)
				if( C4Check[id] == true && cs_get_user_team(id) == CS_TEAM_T)
				{
					give_item( id, "weapon_c4" );
					cs_set_user_plant(id);
				} 
				give_item(id, "weapon_ak47")
				give_item(id, "weapon_deagle")
				give_item(id, "weapon_knife")
				give_item(id, "item_kevlar")
				cs_set_user_bpammo(id, CSW_AK47, 90)
				cs_set_user_bpammo(id, CSW_DEAGLE, 90)
				ColorChat( id, GREEN, "^1[^4Element^1] ^3Zobral si si AK47 + deagle!!");
				Pouzite[id] = true;	
				if(SKINY[id] == false)
				{
					SKINSID[4][id] = true;
					KNIFE[id] = true;
					SKINSID[2][id] = true;
				}
			}
			else
			{
				if(get_user_flags(id) & ADMIN_USER)
				{
					ColorChat( id, GREEN, "^1[^4VIP^1] ^3Nemas VIP!");
				}
				if(Pouzite[id] == true)
				{
					ColorChat( id, GREEN, "^1[^4VIP^1] ^3VIP menu si uz pouzil toto kolo!");
				}
		}}
		case 2:
		{
			if(get_user_flags(id) & ADMIN_LEVEL_H && Pouzite[id] == false)
			{
				strip_user_weapons(id)
				if( C4Check[id] == true && cs_get_user_team(id) == CS_TEAM_T)
				{
					give_item( id, "weapon_c4" );
					cs_set_user_plant(id);
				} 
				give_item(id, "weapon_famas")
				give_item(id, "weapon_deagle")
				give_item(id, "weapon_knife")
				give_item(id, "item_kevlar")
				cs_set_user_bpammo(id, CSW_FAMAS, 90)
				cs_set_user_bpammo(id, CSW_DEAGLE, 90)
				ColorChat( id, GREEN, "^1[^4VIP^1] ^3Zobral si si FAMAS + deagle!!");   
				Pouzite[id] = true;
				if(SKINY[id] == false)
				{
					SKINSID[4][id] = true;
					KNIFE[id] = true;
				}
			}
			else
			{
				if(get_user_flags(id) & ADMIN_USER)
				{
					ColorChat( id, GREEN, "^1[^4VIP^1] ^3Nemas VIP!");
				}
				if(Pouzite[id] == true)
				{
					ColorChat( id, GREEN, "^1[^4VIP^1] ^3VIP menu si uz pouzil toto kolo.");
				}
			}
		}
		case 3:
		{
			if(get_user_flags(id) & ADMIN_LEVEL_G && Pouzite[id] == false)
			{
				strip_user_weapons(id)
				if( C4Check[id] == true && cs_get_user_team(id) == CS_TEAM_T)
				{
					give_item( id, "weapon_c4" );
					cs_set_user_plant(id);
				} 
				give_item(id, "weapon_awp")
				give_item(id, "weapon_deagle")
				give_item(id, "weapon_knife")
				give_item(id, "item_kevlar")
				cs_set_user_bpammo(id, CSW_AWP, 120)
				cs_set_user_bpammo(id, CSW_DEAGLE, 90)
				ColorChat( id, GREEN, "^1[^4EVIP^1] ^3Zobral si si AWP + deagle!!");
				Pouzite[id] = true;
				if(SKINY[id] == false)
				{
					SKINSID[4][id] = true;
					KNIFE[id] = true;
					SKINSID[3][id] = true;
				}
			}
			else
			{
				if(get_user_flags(id) & ADMIN_LEVEL_H && Pouzite[id] == false)
				{
					ColorChat( id, GREEN, "^1[^4Portal.cz^1] ^3Nemas EVIP!");
				}
				else if(get_user_flags(id) & ADMIN_USER && Pouzite[id] == false)
				{
					ColorChat( id, GREEN, "^1[^4Portal.cz^1] ^3Nemas EVIP!");
				}
				if(Pouzite[id] == true)
				{
					ColorChat( id, GREEN, "^1[^4Portal.cz^1] ^3VIP menu si uz pouzil toto kolo!");
				}
			}
		}
		case 4:
		{
			if(get_user_flags(id) & ADMIN_LEVEL_G && Pouzite[id] == false)
			{
				strip_user_weapons(id)
				if( C4Check[id] == true && cs_get_user_team(id) == CS_TEAM_T)
				{
					give_item( id, "weapon_c4" );
					cs_set_user_plant(id);
				} 
				give_item(id, "weapon_m249")
				give_item(id, "weapon_deagle")
				give_item(id, "weapon_knife")
				give_item(id, "item_kevlar")
				cs_set_user_bpammo(id, CSW_M249, 255)
				cs_set_user_bpammo(id, CSW_DEAGLE, 90)
				ColorChat( id, GREEN, "^1[^4EVIP^1] ^3Zobral si si Gulomet + deagle!!");
				Pouzite[id] = true;
				if(SKINY[id] == false)
				{
					SKINSID[4][id] = true;
					KNIFE[id] = true;
				}
			}
			else
			{
				if(get_user_flags(id) & ADMIN_LEVEL_H && Pouzite[id] == false)
				{
					ColorChat( id, GREEN, "^1[^4VIP^1] ^3Nemas EVIP!");
				}
				else if(get_user_flags(id) & ADMIN_USER && Pouzite[id] == false)
				{
					ColorChat( id, GREEN, "^1[^4Portal.cz^1] ^3Nemas EVIP!");
				}
				if(Pouzite[id] == true)
				{
					ColorChat( id, GREEN, "^1[^4Portal.cz^1] ^3VIP menu si uz pouzil toto kolo!");
				}
			}
		}	
		case 5:
		{ 
			show_motd(id, "http://forum.Portal.cz/viewtopic.php?f=9&t=101", "Pravidla serveru Portal.cz :") 
		}
	}
	
	return PLUGIN_HANDLED
}
public skiny_zapnut(id)  
{   
	new menu = menu_create("\y[\rVIP\y] Zapnut/Vypnut Skiny","skinyon_handle")  
	
	menu_additem(menu,"Zapnut Skiny", "1", 0);
	menu_additem(menu,"Vypnut Skiny", "2", 0);
	
	menu_setprop(menu, MPROP_EXITNAME, "\yZavriet") 
	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r") 
	menu_display(id, menu, 0)
}

public skinyon_handle(id,menu,item) 
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	switch(item)
	{ 
		case 0:
		{  
			if(get_user_flags(id) & ADMIN_LEVEL_H)
			{
				SKINSID[4][id] = true;
				KNIFE[id] = true;	
				SKINSID[2][id] = true;
				SKINSID[1][id] = true;
				SKINY[id] = true;
				if(get_user_flags(id) & ADMIN_LEVEL_G)
				{
					SKINSID[3][id] = true;
				}
			}
		} 
		case 1:
		{  
			if(get_user_flags(id) & ADMIN_LEVEL_H)
			{
				SKINSID[4][id] = false;
				KNIFE[id] = false;	
				SKINSID[2][id] = false;
				SKINSID[1][id] = false;
				SKINY[id] = true;
				if(get_user_flags(id) & ADMIN_LEVEL_G)
				{
					SKINSID[3][id] = false;
				}
			}
		}
	}   
	return PLUGIN_HANDLED;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg949\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset129 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1042\\ f0\\ fs16 \n\\ par }
*/
