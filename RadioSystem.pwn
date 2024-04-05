#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>
#include <sampvoice>
#include <streamer>
#define function%0(%1) forward %0(%1); public %0(%1)
#include <Notifikasi>
#include <easyDialog>
#include <strlib>
#include <timerfix>
#include <textdraw-streamer>
main() 
{}

#define forex(%0,%1) for(new %0 = 0; %0 < %1; %0++)
public OnFilterScriptInit()
{
    printf("");
    printf("Voice System & Radio System Loaded..!");
    printf("Remake By Kaiza Aka Kaizaru");
    printf("");
}     
enum
{
	DIALOG_UNUSED,
	DIALOG_RADIO
}
public OnFilterScriptExit() 
{
    return 1;
}

//Local Voice
#define MAX_RADIOS 999
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:StreamTelpon[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:StreamFreq[MAX_RADIOS] = SV_NULL;
new IDStream[MAX_PLAYERS];
new Text:Radio[4];
new PlayerText:VOICETEXTTD[MAX_PLAYERS][1];
new PlayerText: RADIOPLAYER[MAX_PLAYERS][18];
new Text:RadiopTD[2];
//new Text:Radio[4];

new ToggleSays[MAX_PLAYERS];

enum pEnum
{
	pTombolVoiceRadio,
	pRadioVoice,
	Text3D:TagVoice,
	pCallStage,
	pTombolVoice,
	pCallLine,
	pFrekuensi,
	JarakVoice,
	pCall,
	pInjured,
	pFaction
};
new pData[MAX_PLAYERS][pEnum];

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
    if(pData[playerid][pTombolVoiceRadio] == 1)
	{
		if(pData[playerid][pRadioVoice] == 1)
		{
			if(keyid == 0x42 && IDStream[playerid] >= 1) SvAttachSpeakerToStream(StreamFreq[IDStream[playerid]], playerid);
    		ApplyAnimation(playerid, "ped", "phone_talk", 4.1, 1, 1, 1, 1, 1, 1);
			pData[playerid][TagVoice] = CreateDynamic3DTextLabel("[Radio]", 0x3BBD44FF, 0.0, 0.0, 0.2, 10.0, .attachedplayer = playerid, .testlos = 1);
		}
	}
	else if(pData[playerid][pCallStage] == 2)
	{
	    if (keyid == 0x42 && StreamTelpon[playerid]) SvAttachSpeakerToStream(StreamTelpon[playerid], playerid);
	    ApplyAnimation(playerid, "ped", "phone_talk", 4.1, 1, 1, 1, 1, 1, 1);
	    pData[playerid][TagVoice] = CreateDynamic3DTextLabel("[Menelepon]", 0x3BBD44FF, 0.0, 0.0, 0.2, 10.0, .attachedplayer = playerid, .testlos = 1);
	}
	else if(pData[playerid][pTombolVoice] == 1)
	{
		if (keyid == 0x42 && lstream[playerid])  SvAttachSpeakerToStream(lstream[playerid], playerid);
		pData[playerid][TagVoice] = CreateDynamic3DTextLabel("[Berbicara]", 0x3BBD44FF, 0.0, 0.0, 0.2, 10.0, .attachedplayer = playerid, .testlos = 1);
	}
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
	if(pData[playerid][pTombolVoiceRadio] == 1)
	{
		if(pData[playerid][pRadioVoice] == 1)
		{
			if(keyid == 0x42 && IDStream[playerid] >= 1) SvDetachSpeakerFromStream(StreamFreq[IDStream[playerid]], playerid);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
			if(IsValidDynamic3DTextLabel(pData[playerid][TagVoice]))
              DestroyDynamic3DTextLabel(pData[playerid][TagVoice]);
		}
	}
	else if(pData[playerid][pCallStage] == 2)
	{
		if (keyid == 0x42 && StreamTelpon[playerid]) SvDetachSpeakerFromStream(StreamTelpon[playerid], playerid);
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
		if(IsValidDynamic3DTextLabel(pData[playerid][TagVoice]))
              DestroyDynamic3DTextLabel(pData[playerid][TagVoice]);
	}
	else if(pData[playerid][pTombolVoice] == 1)
	{
	    if(IsValidDynamic3DTextLabel(pData[playerid][TagVoice]))
              DestroyDynamic3DTextLabel(pData[playerid][TagVoice]);
		if (keyid == 0x42 && lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
	}
}

public OnPlayerSpawn(playerid)
{
	PlayerTextDrawShow(playerid, VOICETEXTTD[playerid][0]);
	return 1;
}

public OnPlayerConnect(playerid)
{
	RADIOPLAYER[playerid][0] = CreatePlayerTextDraw(playerid, 398.843, 365.916, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][0], 83.000, 169.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][0], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][0], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][0], 0);

	RADIOPLAYER[playerid][1] = CreatePlayerTextDraw(playerid, 397.626, 383.916, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][1], 4.000, 43.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][1], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][1], 226);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][1], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][1], 0);

	RADIOPLAYER[playerid][2] = CreatePlayerTextDraw(playerid, 481.771, 395.666, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][2], 4.000, 43.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][2], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][2], 226);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][2], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][2], 0);

	RADIOPLAYER[playerid][3] = CreatePlayerTextDraw(playerid, 402.591, 358.333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][3], 22.000, 9.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][3], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][3], 226);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][3], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][3], 0);

	RADIOPLAYER[playerid][4] = CreatePlayerTextDraw(playerid, 411.962, 285.166, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][4], 3.000, 81.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][4], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][4], 255);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][4], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][4], 0);

	RADIOPLAYER[playerid][5] = CreatePlayerTextDraw(playerid, 408.682, 279.749, "ld_beat:chit");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][5], 10.000, 10.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][5], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][5], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][5], 0);

	RADIOPLAYER[playerid][6] = CreatePlayerTextDraw(playerid, 403.060, 375.833, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][6], 75.000, 31.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][6], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][6], -1448498689);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][6], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][6], 0);

	RADIOPLAYER[playerid][7] = CreatePlayerTextDraw(playerid, 451.786, 357.750, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][7], 18.000, 9.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][7], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][7], 205);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][7], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][7], 0);

	RADIOPLAYER[playerid][8] = CreatePlayerTextDraw(playerid, 448.975, 355.416, "ld_beat:chit");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][8], 25.000, 5.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][8], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][8], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][8], 0);

	RADIOPLAYER[playerid][9] = CreatePlayerTextDraw(playerid, 484.113, 395.665, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][9], 2.000, 43.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][9], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][9], -2139062017);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][9], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][9], 0);

	RADIOPLAYER[playerid][10] = CreatePlayerTextDraw(playerid, 395.626, 384.333, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][10], 2.000, 43.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][10], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][10], -5963521);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][10], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][10], 0);

	RADIOPLAYER[playerid][11] = CreatePlayerTextDraw(playerid, 439.410, 385.499, "100.0");
	PlayerTextDrawLetterSize(playerid, RADIOPLAYER[playerid][11], 0.360, 1.372);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][11], 2);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][11], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][11], 1);

	RADIOPLAYER[playerid][12] = CreatePlayerTextDraw(playerid, 403.626, 410.916, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][12], 41.000, 9.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][12], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][12], -1448498689);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][12], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][12], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][12], 0);
	PlayerTextDrawSetSelectable(playerid, RADIOPLAYER[playerid][12], 1);

	RADIOPLAYER[playerid][13] = CreatePlayerTextDraw(playerid, 412.410, 411.499, "FREQ");
	PlayerTextDrawLetterSize(playerid, RADIOPLAYER[playerid][13], 0.240, 0.772);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][13], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][13], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][13], 1);

	RADIOPLAYER[playerid][14] = CreatePlayerTextDraw(playerid, 403.626, 421.916, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][14], 41.000, 9.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][14], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][14], -1448498689);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][14], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][14], 0);
	PlayerTextDrawSetSelectable(playerid, RADIOPLAYER[playerid][14], 1);

	RADIOPLAYER[playerid][15] = CreatePlayerTextDraw(playerid, 410.410, 422.499, "POWER");
	PlayerTextDrawLetterSize(playerid, RADIOPLAYER[playerid][15], 0.240, 0.772);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][15], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][15], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][15], 1);

	RADIOPLAYER[playerid][16] = CreatePlayerTextDraw(playerid, 403.626, 432.916, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, RADIOPLAYER[playerid][16], 41.000, 9.000);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][16], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][16], -1448498689);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][16], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][16], 4);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][16], 0);
	PlayerTextDrawSetSelectable(playerid, RADIOPLAYER[playerid][16], 1);

	RADIOPLAYER[playerid][17] = CreatePlayerTextDraw(playerid, 416.410, 433.499, "TTP");
	PlayerTextDrawLetterSize(playerid, RADIOPLAYER[playerid][17], 0.240, 0.772);
	PlayerTextDrawAlignment(playerid, RADIOPLAYER[playerid][17], 1);
	PlayerTextDrawColor(playerid, RADIOPLAYER[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, RADIOPLAYER[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, RADIOPLAYER[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, RADIOPLAYER[playerid][17], 255);
	PlayerTextDrawFont(playerid, RADIOPLAYER[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, RADIOPLAYER[playerid][17], 1);	

	VOICETEXTTD[playerid][0] = CreatePlayerTextDraw(playerid, 607.000, 429.000, "~w~NORMAL[RANGE]");
	PlayerTextDrawLetterSize(playerid, VOICETEXTTD[playerid][0], 0.260, 1.399);
	PlayerTextDrawAlignment(playerid, VOICETEXTTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, VOICETEXTTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, VOICETEXTTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, VOICETEXTTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, VOICETEXTTD[playerid][0], 150);
	PlayerTextDrawFont(playerid, VOICETEXTTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, VOICETEXTTD[playerid][0], 1);

    if (SvGetVersion(playerid) == SV_NULL)
    {
		new lstr[512];
		format(lstr, sizeof(lstr), "Dari: Penjaga Kota PearlCity\nKepada: Aktor (pemain) Roleplay\n\nUntuk bermain peran di PearlCity Roleplay, maka anda harus memenuhi salah satu syarat yaitu memasang plugin voice Discord: {FFFF00}bit.ly/PearlCityRp");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{FFFFFF}PearlCity Roleplay - Plugins Tidak Terdeteksi", lstr, "Keluar", "");
		SendClientMessage(playerid, -1, "{FFFF00}[i] Anda telah ditendang dari server karena {FF0000}Plugin Voice {FFFF00}tidak terdeteksi!");
    }
    else if (SvHasMicro(playerid) == SV_FALSE)
    {
        SendClientMessage(playerid, -1, "The microphone could not be found.");
    }
    else if ((lstream[playerid] = SvCreateDLStreamAtPlayer(15.0, SV_INFINITY, playerid, 0xff0000ff, "Berbicara")))
    {
        SendClientMessage(playerid, -1, "[i] Selalu ingat bahwa server(kota) ini menggunakan voice only, dilarang keras untuk RP bisu/tuli!");
        SendClientMessage(playerid, -1, "[i] Selama didalam server(kota) ingatlah aturan pokok {ff0000}PearlCity Roleplay{FFFFFF}-> {FFFF00}Respect & Good Attitude!");
        SendClientMessage(playerid, -1, "[!] Diingatkan untuk tidak meniup - niup mic dan menggunakan headset(Alat)");
        SvAddKey(playerid, 0x42);
    }
    pData[playerid][pRadioVoice] = 0;
	pData[playerid][pTombolVoice] = 1;
	pData[playerid][pTombolVoiceRadio] = 0;
}

public OnPlayerDisconnect(playerid, reason)
{
	ToggleSays[playerid] = 0;
    if (lstream[playerid])
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }
	return 1;
}

public OnGameModeInit()
{
    //TextDraw Radio
 	Radio[0] = TextDrawCreate(985.000000, 195.000000, "");
	TextDrawFont(Radio[0], 5);
	TextDrawLetterSize(Radio[0], 0.600000, 2.000000);
	TextDrawTextSize(Radio[0], 234.000000, 273.500000);
	TextDrawSetOutline(Radio[0], 0);
	TextDrawSetShadow(Radio[0], 0);
	TextDrawAlignment(Radio[0], 1);
	TextDrawColor(Radio[0], -1);
	TextDrawBackgroundColor(Radio[0], 0);
	TextDrawBoxColor(Radio[0], 255);
	TextDrawUseBox(Radio[0], 0);
	TextDrawSetProportional(Radio[0], 1);
	TextDrawSetSelectable(Radio[0], 0);

    Radio[0] = TextDrawCreate(385.000000, 195.000000, "Preview_Model");
	TextDrawFont(Radio[0], 5);
	TextDrawLetterSize(Radio[0], 0.600000, 2.000000);
	TextDrawTextSize(Radio[0], 234.000000, 273.500000);
	TextDrawSetOutline(Radio[0], 0);
	TextDrawSetShadow(Radio[0], 0);
	TextDrawAlignment(Radio[0], 1);
	TextDrawColor(Radio[0], -1);
	TextDrawBackgroundColor(Radio[0], 0);
	TextDrawBoxColor(Radio[0], 255);
	TextDrawUseBox(Radio[0], 0);
	TextDrawSetProportional(Radio[0], 1);
	TextDrawSetSelectable(Radio[0], 0);
	TextDrawSetPreviewModel(Radio[0], 2967);
	TextDrawSetPreviewRot(Radio[0], -95.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetPreviewVehCol(Radio[0], 1, 1);

	Radio[1] = TextDrawCreate(512.000000, 313.000000, "ld_bum:blkdot");
	TextDrawFont(Radio[1], 4);
	TextDrawLetterSize(Radio[1], 0.600000, 2.000000);
	TextDrawTextSize(Radio[1], 25.500000, 11.500000);
	TextDrawSetOutline(Radio[1], 1);
	TextDrawSetShadow(Radio[1], 0);
	TextDrawAlignment(Radio[1], 1);
	TextDrawColor(Radio[1], -1378294017);
	TextDrawBackgroundColor(Radio[1], 255);
	TextDrawBoxColor(Radio[1], 50);
	TextDrawUseBox(Radio[1], 1);
	TextDrawSetProportional(Radio[1], 1);
	TextDrawSetSelectable(Radio[1], 1);

	Radio[2] = TextDrawCreate(515.000000, 313.000000, "55.55");
	TextDrawFont(Radio[2], 1);
	TextDrawLetterSize(Radio[2], 0.195831, 1.149999);
	TextDrawTextSize(Radio[2], 400.000000, 17.000000);
	TextDrawSetOutline(Radio[2], 0);
	TextDrawSetShadow(Radio[2], 0);
	TextDrawAlignment(Radio[2], 1);
	TextDrawColor(Radio[2], 255);
	TextDrawBackgroundColor(Radio[2], 255);
	TextDrawBoxColor(Radio[2], 50);
	TextDrawUseBox(Radio[2], 0);
	TextDrawSetProportional(Radio[2], 1);
	TextDrawSetSelectable(Radio[2], 0);

	Radio[3] = TextDrawCreate(532.000000, 218.000000, "ld_beat:chit");
	TextDrawFont(Radio[3], 4);
	TextDrawLetterSize(Radio[3], 0.600000, 2.000000);
	TextDrawTextSize(Radio[3], 10.000000, 8.000000);
	TextDrawSetOutline(Radio[3], 1);
	TextDrawSetShadow(Radio[3], 0);
	TextDrawAlignment(Radio[3], 1);
	TextDrawColor(Radio[3], 255);
	TextDrawBackgroundColor(Radio[3], 255);
	TextDrawBoxColor(Radio[3], 50);
	TextDrawUseBox(Radio[3], 1);
	TextDrawSetProportional(Radio[3], 1);
	TextDrawSetSelectable(Radio[3], 1);

	RadiopTD[0] = TextDrawCreate(322.000000, 63.000000, "MIC RADIO");
	TextDrawFont(RadiopTD[0], 3);
	TextDrawLetterSize(RadiopTD[0], 0.920833, 3.249999);
	TextDrawTextSize(RadiopTD[0], 400.000000, 168.500000);
	TextDrawSetOutline(RadiopTD[0], 1);
	TextDrawSetShadow(RadiopTD[0], 0);
	TextDrawAlignment(RadiopTD[0], 2);
	TextDrawColor(RadiopTD[0], -1378294017);
	TextDrawBackgroundColor(RadiopTD[0], 255);
	TextDrawBoxColor(RadiopTD[0], 50);
	TextDrawUseBox(RadiopTD[0], 0);
	TextDrawSetProportional(RadiopTD[0], 1);
	TextDrawSetSelectable(RadiopTD[0], 0);

	RadiopTD[1] = TextDrawCreate(321.000000, 92.000000, "~g~ON");
	TextDrawFont(RadiopTD[1], 3);
	TextDrawLetterSize(RadiopTD[1], 0.920833, 3.249999);
	TextDrawTextSize(RadiopTD[1], 400.000000, 168.500000);
	TextDrawSetOutline(RadiopTD[1], 1);
	TextDrawSetShadow(RadiopTD[1], 0);
	TextDrawAlignment(RadiopTD[1], 2);
	TextDrawColor(RadiopTD[1], -1378294017);
	TextDrawBackgroundColor(RadiopTD[1], 255);
	TextDrawBoxColor(RadiopTD[1], 50);
	TextDrawUseBox(RadiopTD[1], 0);
	TextDrawSetProportional(RadiopTD[1], 1);
	TextDrawSetSelectable(RadiopTD[1], 0);
	return 1;

}

public OnGameModeExit()
{

}

stock GetPName(playerid)
{
	new namep[MAX_PLAYER_NAME+1];
	GetPlayerName(playerid, namep, MAX_PLAYER_NAME+1);
	return namep;
}

stock DisplayMicRadio(playerid)
{
	if(pData[playerid][pCallStage] == 2)
	{
		return ErrorMsg(playerid, "Kamu Sedang Menelpon");
	}
	else if(pData[playerid][pTombolVoiceRadio] == 0)
	{
		if(pData[playerid][pRadioVoice] == 0)
		{
			return ErrorMsg(playerid,"Kamu Tidak Terhubung Ke Frequensi Manapun");
		}
		pData[playerid][pTombolVoiceRadio] = 1;
        InfoTD_RTD(playerid, 3000, "~g~ON");
		SetPlayerAttachedObject(playerid, 9, 19942, 6, 0.083999, 0.030999, 0.000000, -7.699999, -29.100000, -164.100006, 1.000000, 1.000000, 1.000000);
	}
	else if(pData[playerid][pTombolVoiceRadio] == 1)
	{
		pData[playerid][pTombolVoiceRadio] = 0;
		RemovePlayerAttachedObject(playerid, 9);
        InfoTD_RTD(playerid, 3000, "~r~OFF");
	}
	return 1;
}


public OnPlayerClickDynamicTextdraw(playerid, PlayerText:playertextid)
{
	if(playertextid == RADIOPLAYER[playerid][12])
	{
        ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_INPUT, "PearlCity Roleplay - Hubungkan radio", "Silakan tentukan saluran yang ingin Anda hubungkan", "Sambung", "Batal");
	}
	if(playertextid == RADIOPLAYER[playerid][16])
	{
		forex(i, 18)
		{
			PlayerTextDrawHide(playerid, RADIOPLAYER[playerid][i]);
		}		
		CancelSelectTextDraw(playerid);
	}
	return 1;
}

CMD:sr(playerid, params[])
{
	forex(i, 18)
	{
		PlayerTextDrawShow(playerid, RADIOPLAYER[playerid][i]);
	}
	PlayerTextDrawSetString(playerid, RADIOPLAYER[playerid][11], sprintf("%d", pData[playerid][pFrekuensi]));
	SelectTextDraw(playerid, -1);
	return 1;
}

CMD:rr(playerid, params[])
{
    if(pData[playerid][pRadioVoice] == 0)
	{
		return SendClientMessage(playerid, -1, "[i] Anda perlu menghubungkan saluran radio");
    }
    pData[playerid][pRadioVoice] = 0;
	pData[playerid][pTombolVoiceRadio] = 0;
    //SendClientMessage(playerid, "Terputus dari saluran radio.");
    SendClientMessage(playerid, -1, "[i] Terputus dari saluran radio");
    SvDetachListenerFromStream(StreamFreq[IDStream[playerid]], playerid);
	pData[playerid][pFrekuensi] = 0;
	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_RADIO)
	{
		if(response)
        {
			new id;
			if(sscanf(inputtext, "i", id))
			{
				return 1;
			}
			if(pData[playerid][pCallStage] == 2)
			{
				return ErrorMsg(playerid, "Kamu Sedang Menelpon");
			}
			if(!(100 <= id <= 999))
			{
				return ErrorMsg(playerid, "Saluran radio yang ditentukan harus berkisar antara 100 dan 999.");
			}
			if(pData[playerid][pRadioVoice] == 1)
			{
				return ErrorMsg(playerid, "Anda perlu memutuskan sambungan dari saluran radio untuk menghubungkan saluran lain");
			}
			else if(id <= 10)
			{
				if(pData[playerid][pFaction] == 0)
				{
					return ErrorMsg(playerid, "Frekuensi Radio 1 - 10 Hannya Aparat Kepolisian Saja.");
				}
				else
				{
					IDStream[playerid] = id;
					pData[playerid][pFrekuensi] = id;

					if(StreamFreq[IDStream[playerid]] == SV_NULL)
					{
						pData[playerid][pRadioVoice] = 1;
						StreamFreq[IDStream[playerid]] = SvCreateGStream(0xFF0000FF, "Radio");
						SvAttachListenerToStream(StreamFreq[IDStream[playerid]], playerid);
						SuccesMsg(playerid, "> Berhasil terhubung ke saluran radio <");
					}
					else
					{
						pData[playerid][pRadioVoice] = 1;
						SvAttachListenerToStream(StreamFreq[IDStream[playerid]], playerid);
						SuccesMsg(playerid, "> Berhasil terhubung ke saluran radio <");
					}
				}
			}
			else
			{
				IDStream[playerid] = id;
				pData[playerid][pFrekuensi] = id;

				if(StreamFreq[IDStream[playerid]] == SV_NULL)
				{
					pData[playerid][pRadioVoice] = 1;
					StreamFreq[IDStream[playerid]] = SvCreateGStream(0xFF0000FF, "Radio");
					SvAttachListenerToStream(StreamFreq[IDStream[playerid]], playerid);
					SuccesMsg(playerid, "> Berhasil terhubung ke saluran radio <");
				}
				else
				{
					pData[playerid][pRadioVoice] = 1;
					SvAttachListenerToStream(StreamFreq[IDStream[playerid]], playerid);
					SuccesMsg(playerid, "> Berhasil terhubung ke saluran radio <");
				}
			}
        }
    }
	return 1;
}

forward KickPlayerDelayed(playerid);
public KickPlayerDelayed(playerid)
{
	return Kick(playerid);
}


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_NO))
	{
		if(!pData[playerid][JarakVoice])
		{
			SvDeleteStream(lstream[playerid]);
			lstream[playerid] = SV_NULL;
			PlayerTextDrawSetString(playerid, VOICETEXTTD[playerid][0], "~w~TERIAK[RANGE]");
			PlayerTextDrawShow(playerid, VOICETEXTTD[playerid][0]);
			lstream[playerid] = SvCreateDLStreamAtPlayer(20.0, SV_INFINITY, playerid, 0xff0000ff, "Berbicara");
			pData[playerid][JarakVoice] = 1;
		}
		else if(pData[playerid][JarakVoice] == 1)
		{
			SvDeleteStream(lstream[playerid]);
			lstream[playerid] = SV_NULL;
			PlayerTextDrawSetString(playerid, VOICETEXTTD[playerid][0], "~w~BISIK[RANGE]");
			PlayerTextDrawShow(playerid, VOICETEXTTD[playerid][0]);
			lstream[playerid] = SvCreateDLStreamAtPlayer(10.0, SV_INFINITY, playerid, 0xff0000ff, "Berbicara");
			pData[playerid][JarakVoice] = 2;
		}		
		else if(pData[playerid][JarakVoice] == 2)
		{
			SvDeleteStream(lstream[playerid]);
			lstream[playerid] = SV_NULL;
			PlayerTextDrawSetString(playerid, VOICETEXTTD[playerid][0], "~w~NORMAL[RANGE]");
			PlayerTextDrawShow(playerid, VOICETEXTTD[playerid][0]);
			lstream[playerid] = SvCreateDLStreamAtPlayer(15.0, SV_INFINITY, playerid, 0xff0000ff, "Berbicara");
			pData[playerid][JarakVoice] = 0;
		}		
	}	
	if(PRESSED(KEY_WALK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		DisplayMicRadio(playerid);
	}
	if(PRESSED(KEY_LOOK_BEHIND) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		DisplayMicRadio(playerid);
	}
	return 1;
}

function InfoTD_RTD(playerid, ms_time, text[])
{
	if(GetPVarInt(playerid, "InfoTDRshown") != -1)
	{
	    TextDrawHideForPlayer(playerid, RadiopTD[0]);
	    TextDrawHideForPlayer(playerid, RadiopTD[1]);
	    KillTimer(GetPVarInt(playerid, "InfoTDRshown"));
	}

    TextDrawSetString(RadiopTD[1], text);
    TextDrawShowForPlayer(playerid, RadiopTD[0]);
    TextDrawShowForPlayer(playerid, RadiopTD[1]);
	SetPVarInt(playerid, "InfoTDRshown", SetTimerEx("InfoTDR_Hide", ms_time, false, "i", playerid));
}

function InfoTDR_Hide(playerid)
{
	SetPVarInt(playerid, "InfoTDRshown", -1);
	TextDrawHideForPlayer(playerid, RadiopTD[0]);
 	TextDrawHideForPlayer(playerid, RadiopTD[1]);
}