_this = _this select 3;
_art  = _this select 0;
_safe = _this select 1;
_safedoor = _this select 2;

if (_art == "ausrauben") then

{

call compile format["local_cash = robpool%1", _safe];

if(local_cash < 21000)exitwith{player groupchat "Ce coffre-fort a ete recemment vole et il est vide"};

if(!robenable)exitwith{player groupchat "Vous etes deja en train de voler la banque"};
if(!(call INV_isArmed) and !debug)exitWith{player groupChat localize "STRS_bank_rob_noweapon";};
robenable = false;
call compile format["robpool%1 = 0;publicvariable ""robpool%1"";", _safe];
player groupChat format[localize "STRS_bank_rob_info", (robb_money call ISSE_str_IntToStr)];

format['[0,1,2,["opfer", %1, %2]] execVM "bankrob.sqf";', _safe, local_cash] call broadcast;

if (_safedoor == "safe1") then
{
safe1 animate ["Safe_Door",1];
player playmove "AinvPknlMstpSlayWrflDnon_medic";
sleep 5;
waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};
player playmove "AinvPknlMstpSlayWrflDnon_medic";
sleep 5;
waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};
safe1 animate ["Safe_Door",0];
Safecracked1 = FALSE;
};
/*
if (_safedoor == "safe2") then
{
safe2 animate ["Safe_Door",1];
player playmove "AinvPknlMstpSlayWrflDnon_medic";
sleep 5;
waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};
safe2 animate ["Safe_Door",0];
Safecracked2 = FALSE;
};
if (_safedoor == "safe3") then
{
safe3 animate ["Safe_Door",1];
player playmove "AinvPknlMstpSlayWrflDnon_medic";
sleep 5;
waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};
safe3 animate ["Safe_Door",0];
Safecracked3 = FALSE;
};
*/


if (alive player) then

	{

	['geld', local_cash] call INV_AddInvItem;
	player groupChat format[localize "STRS_bank_rob_success"];
	[local_cash] spawn Bank_Rob_End_Script;

	};

stolencash = stolencash + local_cash;

local_useBankPossible = false;
robenable = true;
rblock = rblock + ((local_cash/50000)*60);
_rblock = rblock;

sleep 2;

if(_rblock != rblock)exitwith{};

for [{rblock}, {rblock > -1}, {rblock=rblock-1}] do {sleep 1;};

local_useBankPossible = true;
stolencash = 0;
rblock	   = 0;


};


if (_art == "opfer") then

{

_robpool = _this select 2;

titleText [localize "STRS_bank_rob_titlemsg", "plain"];

_safe say "Bank_alarm";
copbase1 say "Bank_alarm";

sleep 8;

["Bank", "civilian", _robpool] spawn Isse_AddCrimeLogEntry;
server globalchat format["Les voleurs ont prit $%1!", _robpool];

sleep 4;

_percentlost = _robpool/2000000;

if(_percentlost > Maxbankrobpercentlost)then{_percentlost == Maxbankrobpercentlost};

_verlust = round(Kontostand*_percentlost);

if ((Kontostand <= _verlust) and (Kontostand >= 1) and (('bankversicherung' call INV_GetItemAmount) == 0)) then

	{

	Kontostand = 0;
	player groupChat localize "STRS_bank_rob_allmoneylost";

	};

if ((Kontostand >  _verlust) and (('bankversicherung' call INV_GetItemAmount) == 0)) then

	{

	Kontostand = Kontostand - _verlust;
	player groupChat format[localize "STRS_bank_rob_somemoneylost", (_verlust call ISSE_str_IntToStr), (Kontostand call ISSE_str_IntToStr)];

	};

if (('bankversicherung' call INV_GetItemAmount) > 0) then

	{

	player groupChat localize "STRS_bank_rob_lostnomoney";
	['bankversicherung', -(1)] call INV_AddInvItem;

	};

};

