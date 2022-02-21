//magenta dm
#pragma   warning disable                                                  239
#pragma   warning disable                                                  203
#pragma   warning disable                                                  217
#pragma   warning disable                                                  213
#pragma   warning disable                                                  219
#pragma   warning disable                                                  235
#pragma   warning disable                                                  202
#pragma   warning disable                                                  214
#pragma   warning disable                                                  204
#pragma   warning disable                                                  205
#pragma warning disable                                                    225



#include <a_samp>
#include <a_mysql>
#include <easyDialog>
#include <Pawn.CMD>
#include <foreach>
#include <discord-connector>
#include <sscanf2>
#include <weapon-config>
#include <Opba>


//TIMER SÜRELERI
#define   TIMER_SANIYE(%1)    (%1 * 1000)
#define   TIMER_SANIYE_BUCUK(%1)  (%1 * 1500)
#define   TIMER_DAKIKA(%1)    (%1 * 60000)

/////// Oyun modu ayarlarý
#define   SUNUCUADI       "[0.3.DL] ~ Magenta DeathMatch[DM] - [TR/Turkish]"
#define   SUNUCUSIFRE        ""
#define   SUNUCUDIL         "TR/Turkish"
#define   SUNUCUWEB         "dc.gg/j3EBXB2ctV"
#define   MODADI            "MG-DM ~ vALPHA 0.3"


#define MYSQL_IP "127.0.0.1"
#define MYSQL_USER "root"
#define MYSQL_PASSWORD ""
#define MYSQL_TABLO "magenta"

#define function%0(%1) forward %0(%1); public %0(%1)
#define yapistir(%0,%1,%2) strcat((%0[0] = '\0', %0), %1, %2)

//dialogs
#define DIALOG_WEAPS 1231
#define DIALOG_DMLOBILERI 1214
#define DIALOG_KURALLAR 1514
#define DIALOG_TDM 1521
#define DIALOG_YARDIM 3152
#define DIALOG_BANSAYFASI 3122
#define     REPORTLAR     (561)
#define     REPORT_YANIT    (562)

/////// Renkler
#define     SUNUCU_RENK           0x8B0000FF
#define     SUNUCU_RENK2          "{8B0000}"
#define     KIRMIZI               0xD01717FF
#define     KIRMIZI2              "{D01717}"
#define     DONATOR_RENK          0xE15DC1FF
#define     DONATOR_RENK2         "{E15DC1}"
#define     MAVI                  0x05B3FFFF
#define     MAVI2                 "{05B3FF}"
#define     GRI                   0x8F8F8FFF
#define     GRI2                  "{8F8F8F}"
#define     BEYAZ                 0xFFFFFFFF
#define     BEYAZ2                "{FFFFFF}"
#define     BEYAZ3                0xFFFFFF00
#define     YESIL                 0x449C2DFF
#define     YESIL2                "{449C2D}"
#define     TURUNCU               0xF96500FF
#define     TURUNCU2              "{F96500}"
#define     YONETIM_RENK          0xD8AB3FFF
#define     YONETIM_RENK2         "{D8AB3F}"
#define     SUSPECT_RENK          0xEE1616FF
#define     SUSPECT_RENK2         0xEE161600
#define     POLIS_RENK            0x767BA5FF
#define     POLIS_RENK2           0x767BA500
#define     SARI                  0xF0D21DFF
#define     SARI2                 "{F0D21D}"
#define     SARI3                 0xF0D21D00
#define     KAPI_RENK             0x647DA1FF
#define     KAPI_RENK2            "{647DA1}"
#define     EMOTE_RENK            0xC2A2DAFF
#define     EMOTE_RENK2           "{C2A2DA}"
#define     COLOR_ORANGE          0xFF9500FF
#define     DUEL_RENK             0x647DA1FF
#define     DUEL2                 "{647DA1}"
#define     TELSIZ                0x767BA5FF
#define     COLOR_GREY            0xAFAFAFAA


#if !defined IsValidVehicle
    native IsValidVehicle(vehicleid);
#endif
// Pawno kýsayollarý

new     fmesaj[400];
new banSayfasi[MAX_PLAYERS];
// discord baðlantýsý
new DCC_Channel:giris_cikis;
new DCC_Channel:dcbildiri;
new DCC_Channel:yonetim;
new DCC_Channel:konusmalar;
new DCC_Channel:g_Discord_Chat;

main()
{
  printf("[SISTEM] Oyun modu '%s' adýyla açýldý.\n\n", SUNUCUADI);
}
#define   YollaSoruMesaj(%0,%1)     format(fmesaj, sizeof(fmesaj), %1) && SoruMesajDefine(%0, fmesaj)
#define   adminmesaj(%0,%1,%2)  format(fmesaj, sizeof(fmesaj), %2) &&   adminmesajdefine(%0, %1, fmesaj)
#define   bilgimesaj(%0,%1)      format(fmesaj, sizeof(fmesaj), %1) &&   bilgimesajdefine(%0, fmesaj)
#define   kullanmesaj(%0,%1)     format(fmesaj, sizeof(fmesaj), %1) &&   kullanmesajdefine(%0, fmesaj)
#define   hatamesaj(%0,%1)     format(fmesaj, sizeof(fmesaj), %1) &&   hatamesajdefine(%0, fmesaj)
#define   YollaFormatMesaj(%0,%1,%2)    format(fmesaj, sizeof(fmesaj), %2) &&   SendClientMessage(%0, %1, fmesaj)
#define   YollaHerkeseMesaj(%0,%1)    format(fmesaj, sizeof(fmesaj), %1) &&   SendClientMessageToAll(%0, fmesaj)
#define   PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define ARMEDBODY_USE_HEAVY_WEAPON                      (false)

static
        armedbody_pTick[MAX_PLAYERS];
new RandomMSG[][] =
{
    ""KIRMIZI2"[MG-DM] "BEYAZ2"Discord hesabýnýzý baðlayarak günlük ödüllerden faydalanabilirsiniz. /discord",
    ""KIRMIZI2"[MG-DM] "BEYAZ2"/sorusor komutu ile sunucu hakkýnda bilgi alabilirsiniz."
};

new RandomMSGG[][] =
{
	"MGDM-44527", "MGDM-94734", "MGDM-50753", "MGDM-36539", "MGDM-13074", "MGDM-90186", "MGDM-61642", "MGDM-50579", "MGDM-24009", "MGDM-24851", "MGDM-24300", "MGDM-17771", "MGDM-29958", "MGDM-65728", "MGDM-71145", "MGDM-42154", "MGDM-58623", "MGDM-67944", "MGDM-68308", "MGDM-21437", "MGDM-76393", "MGDM-41189", "MGDM-65419", "MGDM-68528", "MGDM-56703", "MGDM-57195",
	"MGDM-63696", "MGDM-86978", "MGDM-47897", "MGDM-73704", "MGDM-31753", "MGDM-44572", "MGDM-25141", "MGDM-72295", "MGDM-48239", "MGDM-69927", "MGDM-22638", "MGDM-83034", "MGDM-44231", "MGDM-22193", "MGDM-92901", "MGDM-68735", "MGDM-19752", "MGDM-28898", "MGDM-43773", "MGDM-56825", "MGDM-", "MGDM-", "MGDM-", "MGDM-", "MGDM-", "MGDM-"
};

forward SendMSG();
public SendMSG()
{
    new randMSG = random(sizeof(RandomMSG));
    SendClientMessageToAll(-1, RandomMSG[randMSG]);
}

hatamesajdefine(playerid, const mesaj[])
{
  return YollaFormatMesaj(playerid, 0xFF0000FF, "[!]"#BEYAZ2" %s", mesaj);
}

bilgimesajdefine(playerid, const mesaj[])
{
  return YollaFormatMesaj(playerid, 0x87CEEBFF, "[!]"#BEYAZ2" %s", mesaj);
}

kullanmesajdefine(playerid, const mesaj[])
{
  return YollaFormatMesaj(playerid, 0xFFA500FF, "[!]"#BEYAZ2" %s", mesaj);
}


#define MODVERSION "ALPHA"


new MySQL:alomitymerdsql;

new Text:Fpsxd[MAX_PLAYERS];
new FPS[MAX_PLAYERS];
new FPSS[MAX_PLAYERS];

static const antisqlinjection[][] =
{
    "'",
    "#",
    "`",
    "%s",
    "%d",
    "%f"
};

enum cetei
{
	discordKodu[70],
};
new discordDog[MAX_PLAYERS][cetei];

enum sreportData
{
  acildiMi1,
  sGonderen1,
  sSuclu,
  _url1[148]
};
new Reportlar[MAX_PLAYERS][sreportData];

new HATALI_PASS[MAX_PLAYERS];

enum Yasaklar
{
  Yasaklanan[MAX_PLAYER_NAME],
  Yasaklayan[MAX_PLAYER_NAME],
  Sebep[MAX_PLAYER_NAME],
  Bitis,
  IslemTarih,
  YasakIP[16]
}
new bool:TrolMesaji = false;
new bool:GodMode[MAX_VEHICLES];

new Yasakla[MAX_PLAYERS][Yasaklar];
enum OYUNCUDEGISKEN
{
  sqlid,
  adminlevel,
  isim[MAX_PLAYER_NAME+1],
  GirisYapti,
  skor,
  kiyafet,
  para,
  oldurme,
  olme,
  VW,
  Int,
  arac,
  bool: Cbug,
  CbugSilah,
  CbugTimer,
  SusturDakika,
  SusturTimer,
  HapisDakika,
  HapisTimer,
  bool: FreezeDurumu,
  bool: pGOD,

  bool: LVPDDM,
  bool: RCDM,
  bool: CITYDM,
  bool: WAREHOUSEDM,
  bool: HEADSHOTDM,
  bool: LOBI,
  bool: BALLASTEAM,
  bool: ADM,
  bool: GROVETEAM,
  bool: FREEROAM,
  bool: PMizin,
  bool: Soru,
  pMAraba,
  pMArabaID,
  Sorusu[120],
  Float: Pos[4],
  Ilkbakis

};


new OyuncuBilgileri[MAX_PLAYERS][OYUNCUDEGISKEN];

enum
{
  DIALOG_X,
  DIALOG_KAYIT,
  DIALOG_GIRIS,
};


#define LGreenColor   0x00FF04FF
#define RedColor      0xE81010FF

  new LastPosition[MAX_PLAYERS][3];
  new tdmactor;
  new dmactor;
  new freeroamactor;

new DMOda[MAX_PLAYERS];
new TDMOda[MAX_PLAYERS];
new GROVETEAMsayi;
new BALLASTEAMsayi;
new LVPDDMsayi;
new RCDMsayi;
new HEADSHOTDMsayi;
new CITYDMsayi;
new WAREHOUSEDMsayi;


new Float: SilahHasarlari[] =
{
  1.0, // 0 - Fist
  1.0, // 1 - Brass knuckles
  1.0, // 2 - Golf club
  1.0, // 3 - Nitestick
  1.0, // 4 - Knife
  1.0, // 5 - Bat
  1.0, // 6 - Shovel
  1.0, // 7 - Pool cue
  1.0, // 8 - Katana
  1.0, // 9 - Chainsaw
  1.0, // 10 - Dildo
  1.0, // 11 - Dildo 2
  1.0, // 12 - Vibrator
  1.0, // 13 - Vibrator 2
  1.0, // 14 - Flowers
  1.0, // 15 - Cane
  82.5, // 16 - Grenade
  0.0, // 17 - Teargas
  1.0, // 18 - Molotov
  9.9, // 19 - Vehicle M4 (custom)
  46.2, // 20 - Vehicle minigun (custom)
  0.0, // 21
  8.25, // 22 - Colt 45
  13.2, // 23 - Silenced
  46.2, // 24 - Deagle
  3.3, // 25 - Shotgun
  3.3, // 26 - Sawed-off
  4.95, // 27 - Spas
  6.6, // 28 - UZI
  8.25, // 29 - MP5
  9.9, // 30 - AK47
  9.9, // 31 - M4
  6.6, // 32 - Tec9
  24.75, // 33 - Cuntgun
  41.25, // 34 - Sniper
  82.5, // 35 - Rocket launcher
  82.5, // 36 - Heatseeker
  1.0, // 37 - Flamethrower
  46.2, // 38 - Minigun
  82.5, // 39 - Satchel
  0.0, // 40 - Detonator
  0.33, // 41 - Spraycan
  0.33, // 42 - Fire extinguisher
  0.0, // 43 - Camera
  0.0, // 44 - Night vision
  0.0, // 45 - Infrared
  0.0, // 46 - Parachute
  0.0, // 47 - Fake pistol
  2.64, // 48 - Pistol whip (custom)
  9.9, // 49 - Vehicle
  330.0, // 50 - Helicopter blades
  82.5, // 51 - Explosion
  1.0, // 52 - Car park (custom)
  1.0, // 53 - Drowning
  165.0  // 54 - Splat
};

public OnGameModeInit()
{



  AddStaticVehicleEx(560, 1557,34.55,24.16,5.5673, 234,234, 30, 0);
  AddStaticVehicleEx(560, 2501.7771,-1680.8514,13.3787,118.6250, 234,234, 30, 0);
  AddStaticVehicleEx(560, 2485.7573,-1683.0151,13.3342,95.1248, 234,234,30, 0);
  AddStaticVehicleEx(560, 2455.0488,-1331.9827,23.8359,179.3094, 233,233 ,30, 0);
  AddStaticVehicleEx(560, 2455.1660,-1339.0313,24.7031,181.2939, 233,233, 30, 0);
  AddStaticVehicleEx(560, 2455.3040,-1349.7728,23.8359,179.9361, 233,233, 30, 0);

  /*tdmactor = CreateActor(20003,1724.5873,-1655.6481,20.0625,270.6353);
  Create3DTextLabel("{ff0000}TDM SHOT! OR /tdm",-1,1724.5873,-1655.6481,20.0625,40,0);
  dmactor = CreateActor(20003, 1722.0970,-1658.6248,20.0625, 187.9394);
  Create3DTextLabel("{ff0000}DM SHOT! OR /dm",-1,1722.0970,-1658.6248,20.0625,40,0);
  freeroamactor = CreateActor(20003,1719.1204,-1655.8524,20.0625,91.9043);
  Create3DTextLabel("{ff0000}FREEROAM SHOT! OR /freeraom",-1,1719.1204,-1655.8524,20.0625,40,0);
  SetTimer("SendMSG", 100000, true);*/
  DisableInteriorEnterExits();
  SetGameModeText(MODVERSION);
  MysqlBaglanti();
    giris_cikis = DCC_FindChannelByName("giris-cikis"); // Bulunacak kanal.
    dcbildiri = DCC_FindChannelByName("dcbildiri"); // Bulunacak kanal.
    yonetim = DCC_FindChannelByName("yonetim"); // Bulunacak kanal.
    konusmalar = DCC_FindChannelByName("konusmalar"); // Bulunacak kanal.
    g_Discord_Chat = DCC_FindChannelById("937781029706539088");
    EnableVehicleFriendlyFire();
    SetVehiclePassengerDamage(true);
    SetDisableSyncBugs(true);
    for(new i = 0; i < MAX_VEHICLES; i++) GodMode[i] = false;
    GROVETEAMsayi = 0;
    BALLASTEAMsayi = 0;
    LVPDDMsayi = 0;
    RCDMsayi = 0;
    HEADSHOTDMsayi = 0;
    CITYDMsayi = 0;
    WAREHOUSEDMsayi = 0;
    
    return true;
    
    
    
    
}
forward SunucuGuncelle();
public SunucuGuncelle()
{
    if (LVPDDM < 0) return LVPDDMsayi = 0;
    if (RCDM < 0) return RCDMsayi = 0;
    if (CITYDM < 0) return CITYDMsayi = 0;
    if (HEADSHOTDM < 0) return HEADSHOTDMsayi = 0;
    if (GROVETEAM < 0) return GROVETEAMsayi = 0;
    if (BALLASTEAM < 0) return BALLASTEAMsayi = 0;
    if (WAREHOUSEDM < 0) return WAREHOUSEDMsayi = 0;
    return 1;
}
forward OnCheatDetected(playerid, ip_address[], type, code);
public OnCheatDetected(playerid, ip_address[], type, code)
{
    if(type) BlockIpAddress(ip_address, 0);
    else
    {
        switch(code)
        {
            case 0:
            {
                adminmesaj(1, 0xEE1616FF, "YONETIM: %s adlý oyuncu airbreak/teleport hilesi kullandýðý için kicklendi  [IP: %s]", OyuncuAdiGetir(playerid), IPGetir(playerid));
                Kickle(playerid);
                return 1;
            }
            case 1:
            {
                adminmesaj(1, 0xEE1616FF, "YONETIM: %s adlý oyuncu airbreak/teleport hilesi kullanýyor olabilir.[IP: %s]", OyuncuAdiGetir(playerid), type,  IPGetir(playerid));
                return 1;
            }
        }
    }
 return 1;
}

forward MysqlBaglanti();
public MysqlBaglanti()
{

  new MySQLOpt:options = mysql_init_options();
  mysql_set_option(options, AUTO_RECONNECT, true);
  mysql_log(ERROR);
  alomitymerdsql = mysql_connect(MYSQL_IP, MYSQL_USER, MYSQL_PASSWORD, MYSQL_TABLO);
  if(mysql_errno(alomitymerdsql) != 0)
  {
    print("[MAGENTA] MySQL baðlantýsý baþarýsýz!");
  }
  else
  {
    print("[MAGENTA] MySQL baðlantýsý kuruldu!");
  }
  return true;
}

public OnGameModeExit()
{

    print("[MAGENTA] MySQL baðlantýsý baþarýsýz olduðu için mysql baðlantýlarý kapatýlýyor.");
    mysql_close(alomitymerdsql);
  return true;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
   if(OyuncuBilgileri[playerid][GirisYapti] == 0)
   {
   SendClientMessage(playerid,-1,"{ff0000}[!]{ffffff} Giriþ yapmadan komut kullanamazsýnýz.");
   return 0;
   }
   return true;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
  printf("%s: /%s", OyuncuAdiGetir(playerid), cmd);
  if(result == -1)
    return hatamesaj(playerid, "Geçersiz komut, /yardim komutuna bakýn.");
  return 1;
}
forward OyuncuSustur(playerid);
public OyuncuSustur(playerid)
{
  OyuncuBilgileri[playerid][SusturDakika]--;
  if(OyuncuBilgileri[playerid][SusturDakika] <= 0)
  {
    OyuncuBilgileri[playerid][SusturDakika] = 0;
    KillTimer(OyuncuBilgileri[playerid][SusturTimer]);
    bilgimesaj(playerid, "Susturmanýn süresi bitti artýk konuþabilirsin.");
  }
  return 1;
}
forward OyuncuHapis(playerid);
public OyuncuHapis(playerid)
{
  OyuncuBilgileri[playerid][HapisDakika]--;
  if(OyuncuBilgileri[playerid][HapisDakika] <= 0)
  {
    OyuncuBilgileri[playerid][HapisDakika] = 0;
    bilgimesaj(playerid, "Hapis süresi bitti.");
    LobiyeDon(playerid);
    KillTimer(OyuncuBilgileri[playerid][HapisTimer]);
  }
  return 1;
}
forward CBugFreeze(playerid);
public CBugFreeze(playerid)
{
  TogglePlayerControllable(playerid, 1);
  OyuncuBilgileri[playerid][Cbug] = false;
  return 1;
}

public OnPlayerText(playerid, text[])
{
    if(OyuncuBilgileri[playerid][SusturDakika] >= 1)
    {
    hatamesaj(playerid, "Susturulduðun için konuþamazsýn, susturmanýn bitmesine %d kaldý.", OyuncuBilgileri[playerid][SusturDakika]);
    return 0;
    }
    if(OyuncuBilgileri[playerid][GirisYapti] == 0)
    {
    SendClientMessage(playerid,-1,"{ff0000}[!]{ffffff} Giriþ yapmadan konuþamazsýnýz.");
    return 0;
    }
        new string[128 + MAX_PLAYER_NAME];
    if (konusmalar)
    {
    format(string, sizeof(string), "``[%s] %s(%d) sunu dedi: %s``",TRcevir(YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel])) ,TRcevir(OyuncuAdiGetir(playerid)), playerid, TRcevir(text));
    DCC_SendChannelMessage(konusmalar, string);

    new upperCount;
    for(new i, j = strlen(text)-1; i < j; i ++)
    {
        if(('A' <= text[i] <= 'Z') && ('A' <= text[i+1] <= 'Z')) { upperCount ++; }
    }
  if(strlen(text) > 6 && upperCount >= strlen(text)/4) // Buradaki 5 bir önlem, 5 harfe kadar tamamen büyük harf kullanýmýna izin veriyor. (Sadece "NASA", "FPS" gibi kelimeleri kullanabilecekler için)
    {
    SendClientMessage(playerid, -1, "{ff0000}[!]{ffffff} Caps-Lock açýk þekilde konuþmak yasaktýr!");
    upperCount = 0;
        return 0;
    }
    if(AileviKoruma(text))
  {
      hatamesaj(playerid, "Küfür tespit edildi, lütfen üslübünüzü düzeltin.");
      return 0;
  }
    new mesaj[150];
  if(OyuncuBilgileri[playerid][adminlevel] >= 1 && OyuncuBilgileri[playerid][GROVETEAM] == true)
  {
          format(mesaj, sizeof(mesaj), ""#BEYAZ2"[%s] %s(%d):"#BEYAZ2" %s",YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]), OyuncuAdiGetir(playerid), playerid, text);
    YollaHerkeseMesaj(000,mesaj, GetPlayerColor(playerid));
      return 0;
  }
  if(OyuncuBilgileri[playerid][adminlevel] >= 1 && OyuncuBilgileri[playerid][BALLASTEAM] == true)
  {
         format(mesaj, sizeof(mesaj), ""#BEYAZ2"[%s] %s(%d):"#BEYAZ2" %s",YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]), OyuncuAdiGetir(playerid), playerid, text);
    YollaHerkeseMesaj(000,mesaj, GetPlayerColor(playerid)); //tdm
      return 0;
  }
  if(OyuncuBilgileri[playerid][adminlevel] >= 1 && OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true || OyuncuBilgileri[playerid][HEADSHOTDM] == true)
  {
    format(mesaj, sizeof(mesaj), ""#BEYAZ2"[%s] %s(%d):"#BEYAZ2" %s",YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]), OyuncuAdiGetir(playerid), playerid, text);
    YollaHerkeseMesaj(000,mesaj, GetPlayerColor(playerid));
    return 0;
  }
  if(OyuncuBilgileri[playerid][adminlevel] >= 1 && OyuncuBilgileri[playerid][LOBI] == true)
  {
    format(mesaj, sizeof(mesaj), ""#BEYAZ2"[%s] [LOBI] %s(%d):"#BEYAZ2" %s",YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]), OyuncuAdiGetir(playerid), playerid, text);
    YollaHerkeseMesaj(000,mesaj, GetPlayerColor(playerid));
    return 0;
  }
    if(OyuncuBilgileri[playerid][GROVETEAM] == true)
    {
      format(mesaj, sizeof(mesaj), ""#BEYAZ2"[%s] %s(%d):"#BEYAZ2" %s",YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]), OyuncuAdiGetir(playerid), playerid, text);
    YollaHerkeseMesaj(000,mesaj, GetPlayerColor(playerid)); //tdm
      return 0;
    }
    if(OyuncuBilgileri[playerid][BALLASTEAM] == true)
    {
       format(mesaj, sizeof(mesaj), ""#BEYAZ2"[%s] %s(%d):"#BEYAZ2" %s",YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]), OyuncuAdiGetir(playerid), playerid, text);
    YollaHerkeseMesaj(000,mesaj, GetPlayerColor(playerid)); //tdm
      return 0;
    }
    if(OyuncuBilgileri[playerid][BALLASTEAM] == true || OyuncuBilgileri[playerid][GROVETEAM] == true || OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true || OyuncuBilgileri[playerid][HEADSHOTDM] == true)
    {
   format(mesaj, sizeof(mesaj), ""#BEYAZ2"[%s] %s(%d):"#BEYAZ2" %s",YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]), OyuncuAdiGetir(playerid), playerid, text);
    YollaHerkeseMesaj(000,mesaj, GetPlayerColor(playerid));
    return 0;
    }
    if(OyuncuBilgileri[playerid][LOBI] == true)
    {
      format(mesaj, sizeof(mesaj), ""#BEYAZ2"[%s] [LOBI] %s(%d):"#BEYAZ2" %s",YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]), OyuncuAdiGetir(playerid), playerid, text);
    YollaHerkeseMesaj(000,mesaj, GetPlayerColor(playerid));
    return 0;
    }
    }


    return 1;
}
stock AileviKoruma(text[])
{
    if(strfind(text, "Anneni Sikerim", true) != -1 || strfind(text, "Ananý Sikerim", true) != -1 || strfind(text, "Orospu Çocuðu", true) != -1 || strfind(text, "Amýn Oðlu", true) != -1 || strfind(text, "Ablaný Sikerim", true) != -1 || strfind(text, "sikerim", true) != -1\
  || strfind(text, "Sülaleni Sikerim", true) != -1 || strfind(text, "Sulaleni Sikerim", true) != -1 || strfind(text, "Anani Sikerim", true) != -1 || strfind(text, "Orospu Evladý", true) != -1 || strfind(text, "Orospu Evladi", true) != -1 || strfind(text, "amk evladý", true) != -1 || strfind(text, "amk cocu", true) != -1\
  || strfind(text, "amk cocugu", true) != -1 || strfind(text, "aq cocu", true) != -1 || strfind(text, "aq çocuðu", true) != -1 || strfind(text, "amk çocuðu", true) != -1 || strfind(text, "aq çocu", true) != -1 || strfind(text, "Dedeni Sikerim", true) != -1 || strfind(text, "Ananýn amý", true) != -1 || strfind(text, "Annenin amý", true) != -1\
  || strfind(text, "aq", true) != -1 || strfind(text, "mq", true) != -1 || strfind(text, "orospu", true) != -1 || strfind(text, "orusbu", true) != -1 || strfind(text, "orspu", true) != -1 || strfind(text, "uruspu", true) != -1)
    {
        return 1;
    }
  return 0;
}
stock SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
{
  static
      args,
      start,
      end,
      string[144]
  ;
  #emit LOAD.S.pri 8
  #emit STOR.pri args

  if (args > 16)
  {
    #emit ADDR.pri str
    #emit STOR.pri start

      for (end = start + (args - 16); end > start; end -= 4)
    {
          #emit LREF.pri end
          #emit PUSH.pri
    }
    #emit PUSH.S str
    #emit PUSH.C 144
    #emit PUSH.C string

    #emit LOAD.S.pri 8
    #emit CONST.alt 4
    #emit SUB
    #emit PUSH.pri

    #emit SYSREQ.C format
    #emit LCTRL 5
    #emit SCTRL 4

        foreach (new i : Player)
    {
      if (IsPlayerNearPlayer(i, playerid, radius)) {
          SendClientMessage(i, color, string);
      }
    }
    return 1;
  }
 foreach (new i : Player)
  {
    if (IsPlayerNearPlayer(i, playerid, radius)) {
      SendClientMessage(i, color, str);
    }
  }
  return 1;
}
stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
  static
    Float:fX,
    Float:fY,
    Float:fZ;

  GetPlayerPos(targetid, fX, fY, fZ);

  return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}
public OnPlayerRequestClass(playerid, classid)
{
    //SetSpawnInfo(playerid, 0, 0, 2008.4701, 1167.4783, 10.8203, 271.0809, 0, 0, 0, 0, 0, 0);
  return true;
}
CMD:vwbak(playerid)
{
    new vw = GetPlayerVirtualWorld(playerid);
    new int = GetPlayerInterior(playerid);
    bilgimesaj(playerid, "VW: %d, INT: %d", vw, int);
    return 1;
}

CMD:sorusor(playerid, params[])
{
  new soru[120];
    if(sscanf(params, "s[120]", soru))
      return kullanmesaj(playerid, "/sorusor [soru]");
    if(OyuncuBilgileri[playerid][Soru] == true)
      return hatamesaj(playerid, "Aktif bir sorunuz var, sorunuzu iptal etmek için /soruiptal yazýn.");

    if(strlen(soru) > 120)
      return hatamesaj(playerid, "Sorunuz 120 karakterden fazla olamaz.");

    OyuncuBilgileri[playerid][Soru] = true;
    OyuncuBilgileri[playerid][Sorusu] = soru;
    bilgimesaj(playerid, "Sorun gönderildi. /kurallar komudunu kullanarakta bilgi edinebilirsin.");
    YollaSoruMesaj(0x05B3FFFF, "[SORU] %s [%s(%d)]", soru, OyuncuAdiGetir(playerid), playerid);
    YollaSoruMesaj(0x05B3FFFF, "Soruya cevap vermek için /sorucevap komutunu kullanabilirsin.");
  return 1;
}
CMD:sorucevap(playerid, params[])
{
      if(OyuncuBilgileri[playerid][adminlevel] < 1 && OyuncuBilgileri[playerid][skor] < 249)
        return hatamesaj(playerid, "Sorularý yalnýzca yöneticiler cevaplayabilir.");

    new hedefid, cevap[120];
      if(sscanf(params, "us[120]", hedefid, cevap))
        return kullanmesaj(playerid, "/sorucevap [hedef adý/ID] [cevap]");
      if(!IsPlayerConnected(hedefid))
      return OyundaDegilMesaj(playerid);
      if(OyuncuBilgileri[hedefid][Soru] == false)
        return hatamesaj(playerid, "Bu oyuncunun aktif sorusu yok.");

      YollaHerkeseMesaj(0x05B3FFFF, "[SORU]"#BEYAZ2" %s [%s(%d)]", OyuncuBilgileri[hedefid][Sorusu], OyuncuAdiGetir(hedefid), hedefid);
      YollaHerkeseMesaj(0x05B3FFFF, "[CEVAP]"#BEYAZ2" %s [%s yanýt verdi.]", cevap, OyuncuAdiGetir(playerid));
      OyuncuBilgileri[hedefid][Soru] = false;
      format(OyuncuBilgileri[hedefid][Sorusu], 100, "-");

    return 1;
}

CMD:sorured(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] >= 1)
  {
    new hedefid, sebep[120];
      if(sscanf(params, "us[120]", hedefid, sebep))
        return kullanmesaj(playerid, "/sorured [hedef adý/ID] [sebep]");

      if(OyuncuBilgileri[hedefid][Soru] == false)
        return hatamesaj(playerid, "Bu oyuncunun aktif sorusu yok.");

      adminmesaj(1, 0x008000FF, "%s adlý admin %s adlý oyuncunun sorusunu reddetti, sebep: %s", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid), sebep);
    bilgimesaj(hedefid, "Sorunuz %s adlý yetkili tarafýndan red edildi, lütfen kurallarý okuyup tekrar atýn. Sebep: %s", OyuncuAdiGetir(playerid), sebep);
      OyuncuBilgileri[hedefid][Soru] = false;
      format(OyuncuBilgileri[hedefid][Sorusu], 100, "-");
  }
  return 1;
}

CMD:soruiptal(playerid, params[])
{
    if(OyuncuBilgileri[playerid][Soru] == false)
      return hatamesaj(playerid, "Aktif sorun yok.");
    OyuncuBilgileri[playerid][Soru] = false;
    format(OyuncuBilgileri[playerid][Sorusu], 100, "-");
    bilgimesaj(playerid, "Göndermiþ olduðunuz soruyu iptal ettiniz.");
  return 1;
}
CMD:skinidim(playerid, params[])
{

 bilgimesaj(playerid, "Skin idniz: %d", OyuncuBilgileri[playerid][kiyafet]);
 return 1;
}
CMD:ahelp(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 1)
    return 1;

  YollaFormatMesaj(playerid, -1, ""#MAVI2"Moderatör"#BEYAZ2": a, kick, goto, gethere, freeze, setvw, setint, god, aspec, aspecoff, sorucevap, sorured, amute, spawngonder, atamir");
  if(OyuncuBilgileri[playerid][adminlevel] >= 2)
  {
    YollaFormatMesaj(playerid, -1, ""#YESIL2"Game Admin"#BEYAZ2": gotocar, getcar,respawncar, slap, ban, unban, offban, setskin, jail, unjail");
  }
  if(OyuncuBilgileri[playerid][adminlevel] >= 3)
  {
    YollaFormatMesaj(playerid, -1, ""#TURUNCU2"Lead Admin"#BEYAZ2": gotopos,dmsifirla, settime, setweather, sethp, sethpall, setarmor");
  }
  if(OyuncuBilgileri[playerid][adminlevel] >= 4)
    YollaFormatMesaj(playerid, -1, ""#KIRMIZI2"Management"#BEYAZ2": restart, aparaver, adminyap, makeadmin");
  return 1;
}
CMD:setweather(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 3)
    return 1;
  new havaid;
  if(sscanf(params, "d", havaid))
    return kullanmesaj(playerid, "/setweather [havadurumu ID]");

  SetWeather(havaid);
  YollaHerkeseMesaj(0x008000FF, "[BILGI]"#BEYAZ2" Hava durumu %s adlý yetkili tarafýndan deðiþtirildi.", OyuncuAdiGetir(playerid));
  return 1;
}

CMD:settime(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 3)
    return 1;
  new saat;
  if(sscanf(params, "d", saat))
    return kullanmesaj(playerid, "/settime [saat]");

  SetWorldTime(saat);
  YollaHerkeseMesaj(0x008000FF, "[BILGI]"#BEYAZ2" Saat %s adlý yetkili tarafýndan deðiþtirildi.", OyuncuAdiGetir(playerid));
  return 1;
}

CMD:dmsifirla(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 3) return 0;
    if(OyuncuBilgileri[playerid][GirisYapti] == true)
      OyuncuBilgileri[playerid][oldurme] = OyuncuBilgileri[playerid][olme] = 0;

  mysql_tquery(alomitymerdsql, "UPDATE hesaplar SET oldurme = 0, olum = 0");
  adminmesaj(1, YONETIM_RENK, "[YONETIM] %s adlý yetkili DM istatistiklerini sýfýrladý", OyuncuAdiGetir(playerid));
  return 1;
}
/*CMD:muzik(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 1)
    return 1;
  new url[150];
  if(sscanf(params, "s[150]", url))
    return kullanmesaj(playerid, "/muzik [url]");

  foreach(new i : Player)
  {
    if(OyuncuBilgileri[i][GirisYapti] == true)
    {
      PlayAudioStreamForPlayer(i, url);
    }
  }
  YollaHerkeseMesaj(0x008000FF, "[BILGI]"#BEYAZ2" %s tarafýndan müzik deðiþtirildi. /muzikkapat ile kapatabilirsiniz.", OyuncuAdiGetir(playerid));
  return 1;
}

CMD:muzikkapat(playerid, params[])
{
  StopAudioStreamForPlayer(playerid);
  bilgimesaj(playerid, "Müziði kapattýn, tekrar müzik açýlana kadar duymayacaksýn.");
  return 1;
}*/
CMD:animlist(playerid, params[])// 24/02/2014
{

     SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /fall /fallback /injured /akick /push /lowbodypush /handsup /bomb /drunk /getarrested /laugh /sup");
    SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /basket /headbutt /medic /spray /robman /taichi /lookout /kiss /cellin /cellout /crossarms /lay");
 SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /deal /crack /smokeanim /groundsit /chat /chat2 /dance /fucku /strip /hide /vomit /eat /chairsit /reload");
    SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /koface /kostomach /rollfall /carjacked1 /carjacked2 /rcarjack1 /rcarjack2 /lcarjack1 /lcarjack2 /bat");
     SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /lifejump /exhaust /leftslap /carlock /hoodfrisked /lightcig /tapcig /box /lay2 /chant /finger");
     SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /shouting /knife /cop /elbow /kneekick /airkick /gkick /gpunch /fstance /lowthrow /highthrow /aim");
     SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /pee /lean /run /poli /surrender /sit /breathless /seat /rap /cross /ped /jiggy /gesture");
     SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /sleep /smoke /urinate /chora /relax /crabs /stop /wash /mourn /fuck /tosteal");
    SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /followme /greeting /still /hitch /palmbitch /cpranim /giftgiving /slap2 /pump /cheer");
     SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /dj /entrenar /foodeat /wave /slapass /dealer /dealstance /gwalk /inbedright /inbedleft");
   SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /wank /sexy /bj /getup /follow /stand /slapped /slapass /yes /celebrate /win /checkout");
 SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /thankyou /invite1 /scratch /nod /cry /carsmoke /benddown /shakehead /angry");
   SendClientMessage(playerid, -1, "{3BEB5D}[!]{FFFFFF} /cockgun /bar /liftup /putdown /die /joint /bed /lranim");

  return 1;
}
CMD:surrender(playerid,params[])
  {
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetPVarInt(playerid, "Injured") == 0)
    {
        SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
          return 1;
    }

    else return SendClientMessage(playerid,-1,"{FF0000}[!]{FFFFFF} Hatalý animasyon girdiniz.");
  }

CMD:sit(playerid,params[])
  {
      new anim;

        if(sscanf(params, "d", anim)) return SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /sit [1-5]");
        switch(anim){
      case 1: ApplyAnimation(playerid,"BEACH","bather",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"BEACH","Lay_Bac_Loop",4.1, 0, 1, 1, 1, 1, 1);
      case 3: ApplyAnimation(playerid,"BEACH","ParkSit_W_loop",4.1, 0, 1, 1, 1, 1, 1);
      case 4: ApplyAnimation(playerid,"BEACH","SitnWait_loop_W",4.1, 0, 1, 1, 1, 1, 1);
      case 5: ApplyAnimation(playerid,"BEACH","SitnWait_loop_W",4.1, 0, 1, 1, 1, 1, 1);
      case 6: ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.1, 0, 1, 1, 1, 1, 1);
      default: return SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /sit [1-5]");
    }
    return 1;
  }

CMD:sleep(playerid,params[])
  {
    new anim;

    if(sscanf(params, "d", anim)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /sleep [1-2]");
    switch(anim){
      case 1: ApplyAnimation(playerid,"CRACK","crckdeth4",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"CRACK","crckidle2",4.1, 0, 1, 1, 1, 1, 1);
    }
    return 1;
  }
CMD:cheer(playerid,params[])
  {
    new anim;

    if(sscanf(params, "d", anim)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /cheer [1-8]");
    switch(anim){
      case 1: ApplyAnimation(playerid,"ON_LOOKERS","shout_01",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"ON_LOOKERS","shout_02",4.1, 0, 1, 1, 1, 1, 1);
      case 3: ApplyAnimation(playerid,"ON_LOOKERS","shout_in",4.1, 0, 1, 1, 1, 1, 1);
      case 4: ApplyAnimation(playerid,"RIOT","RIOT_ANGRY_B",4.1, 0, 1, 1, 1, 1, 1);
      case 5: ApplyAnimation(playerid,"RIOT","RIOT_CHANT",4.1, 0, 1, 1, 1, 1, 1);
      case 6: ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1, 0, 1, 1, 1, 1, 1);
      case 7: ApplyAnimation(playerid,"STRIP","PUN_HOLLER",4.1, 0, 1, 1, 1, 1, 1);
      case 8: ApplyAnimation(playerid,"OTB","wtchrace_win",4.1, 0, 1, 1, 1, 1, 1);
    }
    return 1;
  }

 CMD:urinate(playerid,params[]){

      if(GetPVarInt(playerid, "Injured") == 1) return SendClientMessage(playerid,-1,"{FF0000}[!]{FFFFFF} Hatalý animasyon girdiniz.");
    SetPlayerSpecialAction(playerid, 68);
    return 1;
  }

CMD:dj(playerid,params[]){
      new anim;

        if(sscanf(params, "d", anim)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /dj [1-4]");
        switch(anim){
      case 1: ApplyAnimation(playerid,"SCRATCHING","scdldlp",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"SCRATCHING","scdlulp",4.1, 0, 1, 1, 1, 1, 1);
      case 3: ApplyAnimation(playerid,"SCRATCHING","scdrdlp",4.1, 0, 1, 1, 1, 1, 1);
      case 4: ApplyAnimation(playerid,"SCRATCHING","scdrulp",4.1, 0, 1, 1, 1, 1, 1);
      default: return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /dj [1-4]");
    }
    return 1;
  }

CMD:breathless(playerid,params[]){
      new anim;

        if(sscanf(params, "d", anim)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /breathless [1-2]");
        switch(anim){
      case 1: ApplyAnimation(playerid,"PED","IDLE_tired",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"FAT","IDLE_tired",4.1, 0, 1, 1, 1, 1, 1);
            default: return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /breathless [1-2]");
    }
    return 1;
  }

CMD:poli(playerid,params[]){
      new anim;

        if(sscanf(params, "d", anim)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /poli [1-2]");
    switch(anim){
      case 1:ApplyAnimation(playerid,"POLICE","CopTraf_Come",4.1, 0, 1, 1, 1, 1, 1);
      case 2:ApplyAnimation(playerid,"POLICE","CopTraf_Stop",4.1, 0, 1, 1, 1, 1, 1);
      default: return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /poli [1-2]");
    }
    return 1;
  }

CMD:seat(playerid,params[]){
      new anim;

        if(sscanf(params, "d", anim)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /seat [1-7]");
    if(anim < 1 || anim > 7) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /seat [1-7]");
    switch(anim){
      case 1: ApplyAnimation(playerid,"Attractors","Stepsit_in",4.1, 0, 1, 1, 1, 1, 1);// Not looping
      case 2: ApplyAnimation(playerid,"CRIB","PED_Console_Loop",4.1, 0, 1, 1, 1, 1, 1);
      case 3: ApplyAnimation(playerid,"INT_HOUSE","LOU_In",4.1, 0, 1, 1, 1, 1, 1); // Not looping
      case 4: ApplyAnimation(playerid,"MISC","SEAT_LR",4.1, 0, 1, 1, 1, 1, 1);
      case 5: ApplyAnimation(playerid,"MISC","Seat_talk_01",4.1, 0, 1, 1, 1, 1, 1);
      case 6: ApplyAnimation(playerid,"MISC","Seat_talk_02",4.1, 0, 1, 1, 1, 1, 1);
      case 7: ApplyAnimation(playerid,"ped","SEAT_down",4.1, 0, 1, 1, 1, 1, 1); // Not looping
    }
    return 1;
  }

CMD:dance(playerid,params[]){
      new dancestyle;
        if(sscanf(params, "d", dancestyle)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /dance [1-3]");
    switch(dancestyle){
      case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
      case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
      case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
      case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
    }
      return 1;
  }

CMD:cross(playerid,params[]){
      new anim;
        if(sscanf(params, "d", anim)) return SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /cross [1-5]");

    switch(anim){
      case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1, 1);
      case 3: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 0, 1, 1, 1, 1, 1);
      case 4: ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop",4.1, 0, 1, 1, 1, 1, 1);
      case 5: ApplyAnimation(playerid,"GRAVEYARD","prst_loopa",4.1, 0, 1, 1, 1, 1, 1);
      default: return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /cross [1-5]");
    }
    return 1;
  }

CMD:jiggy(playerid,params[])
  {
      new anim;
        if(sscanf(params, "d", anim)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /jiggy [1-10]");
    switch(anim){
      case 1: ApplyAnimation(playerid,"DANCING","DAN_Down_A",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"DANCING","DAN_Left_A",4.1, 0, 1, 1, 1, 1, 1);
      case 3: ApplyAnimation(playerid,"DANCING","DAN_Loop_A",4.1, 0, 1, 1, 1, 1, 1);
      case 4: ApplyAnimation(playerid,"DANCING","DAN_Right_A",4.1, 0, 1, 1, 1, 1, 1);
      case 5: ApplyAnimation(playerid,"DANCING","DAN_Up_A",4.1, 0, 1, 1, 1, 1, 1);
      case 6: ApplyAnimation(playerid,"DANCING","dnce_M_a",4.1, 0, 1, 1, 1, 1, 1);
      case 7: ApplyAnimation(playerid,"DANCING","dnce_M_b",4.1, 0, 1, 1, 1, 1, 1);
      case 8: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.1, 0, 1, 1, 1, 1, 1);
      case 9: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.1, 0, 1, 1, 1, 1, 1);
      case 10: ApplyAnimation(playerid,"DANCING","dnce_M_d",4.1, 0, 1, 1, 1, 1, 1);
      default: return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /jiggy [1-10]");
    }
    return 1;
  }

CMD:ped(playerid,params[]){
      new anim;
        if(sscanf(params, "d", anim)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /ped [1-26]");
    switch(anim){
      case 1: ApplyAnimation(playerid,"PED","JOG_femaleA",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"PED","JOG_maleA",4.1, 0, 1, 1, 1, 1, 1);
      case 3: ApplyAnimation(playerid,"PED","WOMAN_walkfatold",4.1, 0, 1, 1, 1, 1, 1);
      case 4: ApplyAnimation(playerid,"PED","run_fat",4.1, 0, 1, 1, 1, 1, 1);
      case 5: ApplyAnimation(playerid,"PED","run_fatold",4.1, 0, 1, 1, 1, 1, 1);
      case 6: ApplyAnimation(playerid,"PED","run_old",4.1, 0, 1, 1, 1, 1, 1);
      case 7: ApplyAnimation(playerid,"PED","Run_Wuzi",4.1, 0, 1, 1, 1, 1, 1);
      case 8: ApplyAnimation(playerid,"PED","swat_run",4.1, 0, 1, 1, 1, 1, 1);
      case 9: ApplyAnimation(playerid,"PED","WALK_fat",4.1, 0, 1, 1, 1, 1, 1);
      case 10: ApplyAnimation(playerid,"PED","WALK_fatold",4.1, 0, 1, 1, 1, 1, 1);
      case 11: ApplyAnimation(playerid,"PED","WALK_gang1",4.1, 0, 1, 1, 1, 1, 1);
      case 12: ApplyAnimation(playerid,"PED","WALK_gang2",4.1, 0, 1, 1, 1, 1, 1);
      case 13: ApplyAnimation(playerid,"PED","WALK_old",4.1, 0, 1, 1, 1, 1, 1);
      case 14: ApplyAnimation(playerid,"PED","WALK_shuffle",4.1, 0, 1, 1, 1, 1, 1);
      case 15: ApplyAnimation(playerid,"PED","woman_run",4.1, 0, 1, 1, 1, 1, 1);
      case 16: ApplyAnimation(playerid,"PED","WOMAN_runbusy",4.1, 0, 1, 1, 1, 1, 1);
      case 17: ApplyAnimation(playerid,"PED","WOMAN_runfatold",4.1, 0, 1, 1, 1, 1, 1);
      case 18: ApplyAnimation(playerid,"PED","woman_runpanic",4.1, 0, 1, 1, 1, 1, 1);
      case 19: ApplyAnimation(playerid,"PED","WOMAN_runsexy",4.1, 0, 1, 1, 1, 1, 1);
      case 20: ApplyAnimation(playerid,"PED","WOMAN_walkbusy",4.1, 0, 1, 1, 1, 1, 1);
      case 21: ApplyAnimation(playerid,"PED","WOMAN_walkfatold",4.1, 0, 1, 1, 1, 1, 1);
      case 22: ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1, 0, 1, 1, 1, 1, 1);
      case 23: ApplyAnimation(playerid,"PED","WOMAN_walkold",4.1, 0, 1, 1, 1, 1, 1);
      case 24: ApplyAnimation(playerid,"PED","WOMAN_walkpro",4.1, 0, 1, 1, 1, 1, 1);
      case 25: ApplyAnimation(playerid,"PED","WOMAN_walksexy",4.1, 0, 1, 1, 1, 1, 1);
      case 26: ApplyAnimation(playerid,"PED","WOMAN_walkshop",4.1, 0, 1, 1, 1, 1, 1);
      default: return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /ped [1-26]");
    }
    return 1;
  }

CMD:rap(playerid,params[]){
      new rapstyle;
        if(sscanf(params, "d", rapstyle)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /rap [1-3]");
    switch(rapstyle){
      case 1: ApplyAnimation(playerid,"RAPPING","RAP_A_Loop",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"RAPPING","RAP_B_Loop",4.1, 0, 1, 1, 1, 1, 1);
      case 3: ApplyAnimation(playerid,"RAPPING","RAP_C_Loop",4.1, 0, 1, 1, 1, 1, 1);
      default: return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /rap [1-3]");
    }
      return 1;
  }

CMD:gesture(playerid,params[]){
      new gesture;
        if(sscanf(params, "d", gesture)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /gesture [1-15]");
    switch(gesture){
      case 1: ApplyAnimation(playerid,"GHANDS","gsign1",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"GHANDS","gsign1LH",4.1, 0, 1, 1, 1, 1, 1);
      case 3: ApplyAnimation(playerid,"GHANDS","gsign2",4.1, 0, 1, 1, 1, 1, 1);
      case 4: ApplyAnimation(playerid,"GHANDS","gsign2LH",4.1, 0, 1, 1, 1, 1, 1);
      case 5: ApplyAnimation(playerid,"GHANDS","gsign3",4.1, 0, 1, 1, 1, 1, 1);
      case 6: ApplyAnimation(playerid,"GHANDS","gsign3LH",4.1, 0, 1, 1, 1, 1, 1);
      case 7: ApplyAnimation(playerid,"GHANDS","gsign4",4.1, 0, 1, 1, 1, 1, 1);
      case 8: ApplyAnimation(playerid,"GHANDS","gsign4LH",4.1, 0, 1, 1, 1, 1, 1);
      case 9: ApplyAnimation(playerid,"GHANDS","gsign5",4.1, 0, 1, 1, 1, 1, 1);
      case 10: ApplyAnimation(playerid,"GHANDS","gsign5",4.1, 0, 1, 1, 1, 1, 1);
      case 11: ApplyAnimation(playerid,"GHANDS","gsign5LH",4.1, 0, 1, 1, 1, 1, 1);
      case 12: ApplyAnimation(playerid,"GANGS","Invite_No",4.1, 0, 1, 1, 1, 1, 1);
      case 13: ApplyAnimation(playerid,"GANGS","Invite_Yes",4.1, 0, 1, 1, 1, 1, 1);
      case 14: ApplyAnimation(playerid,"GANGS","prtial_gngtlkD",4.1, 0, 1, 1, 1, 1, 1);
      case 15: ApplyAnimation(playerid,"GANGS","smkcig_prtl",4.1, 0, 1, 1, 1, 1, 1);
      default: return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /gesture [1-15]");
    }
    return 1;
  }

CMD:smoke(playerid,params[]){
      new gesture;

        if(sscanf(params, "d", gesture)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /smoke [1-2]");
    switch(gesture){
      case 1: ApplyAnimation(playerid,"SMOKING","M_smk_in",4.1, 0, 1, 1, 1, 1, 1);
      case 2: ApplyAnimation(playerid,"SMOKING","M_smklean_loop",4.1, 0, 1, 1, 1, 1, 1);
      default: return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /smoke [1-2]");
    }
    return 1;
  }

CMD:chora(playerid,params[]) { ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:relax(playerid,params[]) { ApplyAnimation(playerid, "CRACK", "crckidle1",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:crabs(playerid,params[]) { ApplyAnimation(playerid,"MISC","Scratchballs_01",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:greeting(playerid,params[]) { ApplyAnimation(playerid,"ON_LOOKERS","Pointup_loop",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:stop(playerid,params[]) { ApplyAnimation(playerid,"PED","endchat_01",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:wash(playerid,params[]) { ApplyAnimation(playerid,"BD_FIRE","wash_up",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:mourn(playerid,params[]) { ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:followme(playerid,params[]) { ApplyAnimation(playerid,"WUZI","Wuzi_follow",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:still(playerid,params[]) { ApplyAnimation(playerid,"WUZI","Wuzi_stand_loop", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:hitch(playerid,params[]) { ApplyAnimation(playerid,"MISC","Hiker_Pose", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:palmbitch(playerid,params[]) { ApplyAnimation(playerid,"MISC","bitchslap",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:cpranim(playerid,params[]) { ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:giftgiving(playerid,params[]) { ApplyAnimation(playerid,"KISSING","gift_give",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:slap2(playerid,params[]) { ApplyAnimation(playerid,"SWEET","sweet_ass_slap",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:drunk(playerid,params[]) { ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:pump(playerid,params[]) { ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:tosteal(playerid,params[]) { ApplyAnimation(playerid,"ped", "ARRESTgun", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:laugh(playerid,params[]) { ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:lookout(playerid,params[])  { ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:robman(playerid,params[]) { ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:hide(playerid,params[]) { ApplyAnimation(playerid, "ped", "cower",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:vomit(playerid,params[]) { ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:eat(playerid,params[]) { ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:crack(playerid,params[]) { ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:fuck(playerid,params[]) { ApplyAnimation(playerid,"PED","fucku",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:taichi(playerid,params[]) { ApplyAnimation(playerid,"PARK","Tai_Chi_Loop", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:entrenar(playerid,params[]) { ApplyAnimation(playerid,"PARK","Tai_Chi_Loop", 4.1, 0, 1, 1, 1, 1, 1); return 1; } // amin para magos
CMD:kiss(playerid,params[]) { ApplyAnimation(playerid,"KISSING","Playa_Kiss_01",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:carjacked1(playerid, params[])//17, 12:58pm, 4/27/2012
{
  ApplyAnimation(playerid,"PED","CAR_jackedLHS",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}
CMD:carjacked2(playerid, params[])//18, 12:59pm, 4/27/2012
{
   ApplyAnimation(playerid,"PED","CAR_jackedRHS",4.1, 0, 1, 1, 1, 1, 1);
     return 1;
}
CMD:handsup(playerid, params[])//19 1:00 pm , 4/27/2012
{
  //SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
  ApplyAnimation(playerid, "ROB_BANK","SHP_HandsUp_Scr",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}
CMD:cellin(playerid, params[])// 20 1:01 pm, 4/27/2012
{
      if(GetPVarInt(playerid, "Injured") == 1) return SendClientMessage(playerid,-1,"{FF0000}[!]{FFFFFF} Hatalý animasyon girdiniz.");
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
    return 1;
}
CMD:cellout(playerid, params[])//21 1:02 pm , 4/27/2012
{
      if(GetPVarInt(playerid, "Injured") == 1) return SendClientMessage(playerid,-1,"{FF0000}[!]{FFFFFF} Hatalý animasyon girdiniz.");
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
    return 1;
}
CMD:bomb(playerid, params[])//23 4/27/2012
{
  ClearAnimations(playerid);
  ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 0, 1, 1, 1, 1, 1); // Place Bomb
  return 1;
}
CMD:getarrested(playerid, params[])//24 4/27/2012
{
  ApplyAnimation(playerid,"ped", "ARRESTgun", 4.1, 0, 1, 1, 1, 1, 1); // Gun Arrest
  return 1;
}
CMD:crossarms(playerid, params[])//28
{
  ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 1, 1); // Arms crossed
  return 1;
}

CMD:lay(playerid, params[])//29
{
  ApplyAnimation(playerid,"BEACH", "bather",4.1, 0, 1, 1, 1, 1, 1); // Lay down
  return 1;
}

CMD:foodeat(playerid, params[])//32
{
  ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 1, 1, 1); // Eat Burger
  return 1;
}

CMD:wave(playerid, params[])//33
{
  ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.1, 0, 1, 1, 1, 1, 1); // Wave
  return 1;
}

CMD:slapass(playerid, params[])//34
{
  ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.1, 0, 1, 1, 1, 1, 1); // Ass Slapping
  return 1;
}

CMD:dealer(playerid, params[])//35
{
  ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 1, 1, 1, 1, 1); // Deal Drugs
  return 1;
}

CMD:groundsit(playerid, params[])//38
{
  ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.1, 0, 1, 1, 1, 1, 1); // Sit
  return 1;
}

CMD:chat(playerid, params[])//39
{
  new num;
  if(sscanf(params, "i", num)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /chat [1-2]");
  if(num > 2 || num < 1) {  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /chat [1-2]"); }
  if(num == 1) { ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1, 0, 1, 1, 1, 1, 1); }
  if(num == 2) { ApplyAnimation(playerid,"MISC","Idle_Chat_02",4.1, 0, 1, 1, 1, 1, 1); }
    return 1;
}

CMD:fucku(playerid, params[])//40
{
  ApplyAnimation(playerid,"PED","fucku",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:chairsit(playerid, params[])//42
{
  ApplyAnimation(playerid,"PED","SEAT_idle",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:fall(playerid, params[])//43
{
  ApplyAnimation(playerid,"PED","KO_skid_front",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:fallback(playerid, params[])//44
{
  ApplyAnimation(playerid, "PED","FLOOR_hit_f", 4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:injured(playerid, params[])//46
{
  ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:sup(playerid, params[])//47
{
  new number;
  if(sscanf(params, "i", number)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /sup [1-3]");
  if(number < 1 || number > 3) {  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /sup [1-3]"); }
  if(number == 1) { ApplyAnimation(playerid,"GANGS","hndshkba",4.1, 0, 1, 1, 1, 1, 1); }
  if(number == 2) { ApplyAnimation(playerid,"GANGS","hndshkda",4.1, 0, 1, 1, 1, 1, 1); }
    if(number == 3) { ApplyAnimation(playerid,"GANGS","hndshkfa_swt",4.1, 0, 1, 1, 1, 1, 1); }
    return 1;
}

CMD:push(playerid, params[])// 49
{
  ApplyAnimation(playerid,"GANGS","shake_cara",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:akick(playerid, params)// 50
{
  ApplyAnimation(playerid,"POLICE","Door_Kick",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lowbodypush(playerid, params[])// 51
{
  ApplyAnimation(playerid,"GANGS","shake_carSH",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:spray(playerid, params[])// 52
{
  ApplyAnimation(playerid,"SPRAYCAN","spraycan_full",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:headbutt(playerid, params[])//53
{
  ApplyAnimation(playerid,"WAYFARER","WF_Fwd",4.1, 0, 1, 1, 1, 1, 1);
  return 1;
}

CMD:medic(playerid, params[])//54
{
  ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:koface(playerid, params[])//55
{
  ApplyAnimation(playerid,"PED","KO_shot_face",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:kostomach(playerid, params[])//56
{
  ApplyAnimation(playerid,"PED","KO_shot_stom",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lifejump(playerid, params[])//57
{
  ApplyAnimation(playerid,"PED","EV_dive",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:exhaust(playerid, params[])//58
{
  ApplyAnimation(playerid,"PED","IDLE_tired",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:leftslap(playerid, params[])//59
{
  ApplyAnimation(playerid,"PED","BIKE_elbowL",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:rollfall(playerid, params[])//60
{
  ApplyAnimation(playerid,"PED","BIKE_fallR",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:carlock(playerid, params[])//61
{
  ApplyAnimation(playerid,"PED","CAR_doorlocked_LHS",4.1, 0, 1, 1, 1, 1, 1);
  return 1;
}

CMD:rcarjack1(playerid, params[])//62
{
  ApplyAnimation(playerid,"PED","CAR_pulloutL_LHS",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lcarjack1(playerid, params[])//63
{
  ApplyAnimation(playerid,"PED","CAR_pulloutL_RHS",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}
CMD:rcarjack2(playerid, params[])//64
{
  ApplyAnimation(playerid,"PED","CAR_pullout_LHS",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lcarjack2(playerid, params[])//65
{
  ApplyAnimation(playerid,"PED","CAR_pullout_RHS",4.1, 0, 1, 1, 1, 1, 1);
  return 1;
}

CMD:hoodfrisked(playerid, params[])//66
{
  ApplyAnimation(playerid,"POLICE","crm_drgbst_01",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lightcig(playerid, params[])//67
{
  ApplyAnimation(playerid,"SMOKING","M_smk_in",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:tapcig(playerid, params[])//68
{
  ApplyAnimation(playerid,"SMOKING","M_smk_tap",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:bat(playerid, params[])//69
{
  ApplyAnimation(playerid,"BASEBALL","Bat_IDLE",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:box(playerid, params[])//70
{
  ApplyAnimation(playerid,"GYMNASIUM","GYMshadowbox",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lay2(playerid, params[])//71
{
  ApplyAnimation(playerid,"SUNBATHE","Lay_Bac_in",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:chant(playerid, params[])//72
{
  ApplyAnimation(playerid,"RIOT","RIOT_CHANT",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:finger(playerid, params[])//73
{
  ApplyAnimation(playerid,"RIOT","RIOT_FUKU",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:shouting(playerid, params[])//74
{
  ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:cop(playerid,params[])//75
{
  ApplyAnimation(playerid,"SWORD","sword_block",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:elbow(playerid, params[])//76
{
  ApplyAnimation(playerid,"FIGHT_D","FightD_3",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:kneekick(playerid, params[])//77
{
  ApplyAnimation(playerid,"FIGHT_D","FightD_2",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:fstance(playerid, params[])//78
{
  ApplyAnimation(playerid,"FIGHT_D","FightD_IDLE",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:gpunch(playerid, params[])//79
{
  ApplyAnimation(playerid,"FIGHT_B","FightB_G",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:airkick(playerid, params[])//80
{
  ApplyAnimation(playerid,"FIGHT_C","FightC_M",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:gkick(playerid, params[])//81
{
  ApplyAnimation(playerid,"FIGHT_D","FightD_G",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lowthrow(playerid, params[])//82
{
  ApplyAnimation(playerid,"GRENADE","WEAPON_throwu",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:highthrow(playerid, params[])//83
{
  ApplyAnimation(playerid,"GRENADE","WEAPON_throw",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:dealstance(playerid, params[])//84
{
  ApplyAnimation(playerid,"DEALER","DEALER_IDLE",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:pee(playerid, params[])//85
{
  if(GetPVarInt(playerid, "Injured") == 1) return SendClientMessage(playerid,-1,"{FF0000}[!]{FFFFFF} Hatalý animasyon girdiniz.");
  SetPlayerSpecialAction(playerid, 68);
    return 1;
}

CMD:knife(playerid, params[])//86
{
  new nbr;
  if(sscanf(params, "i", nbr)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /knife [1-4]");
    if(nbr < 1 || nbr > 4) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /knife [1-4]");
  switch(nbr)
  {
    case 1: { ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Damage",4.1, 0, 1, 1, 1, 1, 1); }
    case 2: { ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Die",4.1, 0, 1, 1, 1, 1, 1); }
    case 3: { ApplyAnimation(playerid,"KNIFE","KILL_Knife_Player",4.1, 0, 1, 1, 1, 1, 1); }
    case 4: { ApplyAnimation(playerid,"KNIFE","KILL_Partial",4.1, 0, 1, 1, 1, 1, 1); }
  }
  return 1;
}

CMD:basket(playerid, params[])//87
{
  new ddr;
  if (sscanf(params, "i", ddr)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /basket [1-6]");
    if(ddr < 1 || ddr > 6) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /basket [1-6]");
    switch(ddr)
  {
    case 1: { ApplyAnimation(playerid,"BSKTBALL","BBALL_idleloop",4.1, 0, 1, 1, 1, 1, 1); }
    case 2: { ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot",4.1, 0, 1, 1, 1, 1, 1); }
    case 3: { ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup",4.1, 0, 1, 1, 1, 1, 1); }
    case 4: { ApplyAnimation(playerid,"BSKTBALL","BBALL_run",4.1, 0, 1, 1, 1, 1, 1); }
    case 5: { ApplyAnimation(playerid,"BSKTBALL","BBALL_def_loop",4.1, 0, 1, 1, 1, 1, 1); }
    case 6: { ApplyAnimation(playerid,"BSKTBALL","BBALL_Dnk",4.1, 0, 1, 1, 1, 1, 1); }
  }
    return 1;
}

CMD:reload(playerid, params[])//88
{
  new result[128];
  if(sscanf(params, "s[24]", result)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /reload [deagle/smg/ak/m4]");
    if(strcmp(result,"deagle", true) == 0)
  {
    ApplyAnimation(playerid,"COLT45","colt45_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
    else if(strcmp(result,"smg", true) == 0)
    {
    ApplyAnimation(playerid,"UZI","UZI_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
  else if(strcmp(result,"ak", true) == 0)
  {
    ApplyAnimation(playerid,"UZI","UZI_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
  else if(strcmp(result,"m4", true) == 0)
  {
    ApplyAnimation(playerid,"UZI","UZI_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
    else {  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /reload [deagle/smg/ak/m4]"); }
    return 1;
}

CMD:gwalk(playerid, params[])//89
{
  new ssr;
  if(sscanf(params, "i", ssr)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /gwalk [1/2]");
  if(ssr < 1 || ssr > 2) {  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /gwalk [1/2]"); }
  if (ssr == 1) { ApplyAnimation(playerid,"PED","WALK_gang1",4.1, 0, 1, 1, 1, 1, 1); }
  if (ssr == 2) { ApplyAnimation(playerid,"PED","WALK_gang2",4.1, 0, 1, 1, 1, 1, 1); }
    return 1;
}

CMD:aim(playerid, params[])//90
{
  new lmb;
  if(sscanf(params, "i", lmb)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF}: /aim [1-3]");
  if(lmb == 1) { ApplyAnimation(playerid,"PED","gang_gunstand",4.1, 0, 1, 1, 1, 1, 1); }
    if(lmb == 2) { ApplyAnimation(playerid,"PED","Driveby_L",4.1, 0, 1, 1, 1, 1, 1); }
    if(lmb == 3) { ApplyAnimation(playerid,"PED","Driveby_R",4.1, 0, 1, 1, 1, 1, 1); }
    else { SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /aim [1-3]"); }
    return 1;
}

CMD:lean(playerid, params[])//91
{
  new mj;
  if(sscanf(params, "i", mj)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /lean [1-2]");
  if(mj < 1 || mj > 2) { SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /lean [1-2]"); }
    if(mj == 1) { ApplyAnimation(playerid,"GANGS","leanIDLE",4.1, 0, 1, 1, 1, 1, 1); }
  if(mj == 2) { ApplyAnimation(playerid,"MISC","Plyrlean_loop",4.1, 0, 1, 1, 1, 1, 1); }
    return 1;
}

CMD:clearanim(playerid, params[])//92
{
      if(GetPVarInt(playerid, "Injured") == 1) return SendClientMessage(playerid,-1,"{FF0000}[!]{FFFFFF} Hatalý animasyon girdiniz.");
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 1.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:strip(playerid, params[])//93
{
  new kj;
    if(sscanf(params, "i", kj)) return  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /strip [1-7]");
  if(kj < 1 || kj > 7) {  SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /strip [1-7]"); }
  if(kj == 1) { ApplyAnimation(playerid,"STRIP", "strip_A", 4.1, 0, 1, 1, 1, 1, 1 ); }
  if(kj == 2) { ApplyAnimation(playerid,"STRIP", "strip_B", 4.1, 0, 1, 1, 1, 1, 1 ); }
    if(kj == 3) { ApplyAnimation(playerid,"STRIP", "strip_C", 4.1, 0, 1, 1, 1, 1, 1 ); }
    if(kj == 4) { ApplyAnimation(playerid,"STRIP", "strip_D", 4.1, 0, 1, 1, 1, 1, 1 ); }
    if(kj == 5) { ApplyAnimation(playerid,"STRIP", "strip_E", 4.1, 0, 1, 1, 1, 1, 1 ); }
    if(kj == 6) { ApplyAnimation(playerid,"STRIP", "strip_F", 4.1, 0, 1, 1, 1, 1, 1 ); }
    if(kj == 7) { ApplyAnimation(playerid,"STRIP", "strip_G", 4.1, 0, 1, 1, 1, 1, 1 ); }
  return 1;
}

CMD:inbedright(playerid, params[])//94
{
  ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_R",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:inbedleft(playerid, params[])//95
{
  ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_L",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:wank(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
   SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /wank [1-2]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid,"PAULNMAC","wank_in",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"PAULNMAC","wank_loop",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}
CMD:sexy(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /sexy [1-8]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid,"SNM","SPANKING_IDLEW",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"SNM","SPANKING_IDLEP",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "3", true) == 0)
  {
    ApplyAnimation(playerid,"SNM","SPANKINGW",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "4", true) == 0)
  {
    ApplyAnimation(playerid,"SNM","SPANKINGP",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "5", true) == 0)
  {
    ApplyAnimation(playerid,"SNM","SPANKEDW",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "6", true) == 0)
  {
    ApplyAnimation(playerid,"SNM","SPANKEDP",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "7", true) == 0)
  {
    ApplyAnimation(playerid,"SNM","SPANKING_ENDW",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "8", true) == 0)
  {
    ApplyAnimation(playerid,"SNM","SPANKING_ENDP",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}

CMD:bj(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /bj [1-4]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_P",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_W",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "3", true) == 0)
  {
    ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_P",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "4", true) == 0)
  {
    ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_W",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}

CMD:stand(playerid, params[])
{
  ApplyAnimation(playerid,"WUZI","Wuzi_stand_loop", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}

CMD:follow(playerid, params[])
{
  ApplyAnimation(playerid,"WUZI","Wuzi_follow",4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
    return 1;
}

CMD:getup(playerid, params[])
{
  ApplyAnimation(playerid,"PED","getup",4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}
CMD:slapped(playerid, params[])
{
  ApplyAnimation(playerid,"SWEET","ho_ass_slapped",4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
    return 1;
}

CMD:win(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /win [1-2]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid,"CASINO","cards_win", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"CASINO","Roulette_win", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}

CMD:celebrate(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /celebrate [1-2]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid,"benchpress","gym_bp_celebrate", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"GYMNASIUM","gym_tread_celebrate", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}

CMD:yes(playerid, params[])
{
  ApplyAnimation(playerid,"CLOTHES","CLO_Buy", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}

CMD:deal(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /deal [1-2]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"DEALER","DRUGS_BUY", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}

CMD:thankyou(playerid, params[])
{
  ApplyAnimation(playerid,"FOOD","SHP_Thank", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}

CMD:invite1(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /invite1 [1-2]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid,"GANGS","Invite_Yes",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"GANGS","Invite_No",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}

CMD:scratch(playerid, params[])
{
  ApplyAnimation(playerid,"MISC","Scratchballs_01", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
    return 1;
}
CMD:checkout(playerid, params[])
{
  ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}
CMD:nod(playerid, params[])
{
  ApplyAnimation(playerid,"COP_AMBIENT","Coplook_nod",4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}
CMD:cry(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /cry [1-2]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}
CMD:bed(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /bed [1-2]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid,"INT_HOUSE","BED_In_L",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"INT_HOUSE","BED_In_R",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "3", true) == 0)
  {
    ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_L", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "4", true) == 0)
  {
    ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_R", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}
CMD:carsmoke(playerid, params[])
{
  ApplyAnimation(playerid,"PED","Smoke_in_car", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}

CMD:angry(playerid, params[])
{
  ApplyAnimation(playerid,"RIOT","RIOT_ANGRY",4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}
CMD:benddown(playerid, params[])
{
  ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}
CMD:shakehead(playerid, params[])
{
  ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}
CMD:cockgun(playerid, params[])
{
  ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}
CMD:bar(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /bar [1-4]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid,"GHANDS","gsign2LH",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid, "BAR", "Barcustom_order", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "3", true) == 0)
  {
    ApplyAnimation(playerid, "BAR", "Barserve_give", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "4", true) == 0)
  {
    ApplyAnimation(playerid, "BAR", "Barserve_glass", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}
CMD:liftup(playerid, params[])
{
  ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}

CMD:putdown(playerid, params[])
{
  ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}

CMD:joint(playerid, params[])
{
  ApplyAnimation(playerid,"GANGS","smkcig_prtl",4.1, 0, 1, 1, 1, 1, 1);
  SetPVarInt(playerid, "UsingAnim", 1);
  return 1;
}
CMD:die(playerid, params[])
{
  new choice[32];
  if(sscanf(params, "s[32]", choice))
  {
     SendClientMessage(playerid,-1,"{3BEB5D}[!]{FFFFFF} /die [1-2]");
    return 1;
  }
  if(strcmp(choice, "1", true) == 0)
  {
    ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Die",4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  if(strcmp(choice, "2", true) == 0)
  {
    ApplyAnimation(playerid, "PARACHUTE", "FALL_skyDive_DIE", 4.1, 0, 1, 1, 1, 1, 1);
    SetPVarInt(playerid, "UsingAnim", 1);
  }
  return 1;
}
CMD:tsandalye(playerid, params[])
{
  ApplyAnimation(playerid, "PED", "SEAT_IDLE", 4.1, 0, 0, 0, 1, 0, 1);
        SetPlayerAttachedObject(playerid,0,1369,1,-0.276000,0.089999,-0.011999,178.699661,92.599975,3.100000,0.876001,0.734000,0.779000);
        return 1;
        }
CMD:ksandalye(playerid, params[])
 {
        ApplyAnimation(playerid, "PED", "SEAT_UP", 4.0, 0, 0, 0, 0, 0, 1);
        RemovePlayerAttachedObject(playerid , 0);
        return 1;
    }
    stock SetPlayerForwardVelocity(playerid, Float:Velocity, Float:Z)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new Float:Angle;
    new Float:SpeedX, Float:SpeedY;
    GetPlayerFacingAngle(playerid, Angle);
    SpeedX = floatsin(-Angle, degrees);
    SpeedY = floatcos(-Angle, degrees);
    SetPlayerVelocity(playerid, floatmul(Velocity, SpeedX), floatmul(Velocity, SpeedY), Z);

    return 1;
}

CMD:skin(playerid,params[])
{
   if(OyuncuBilgileri[playerid][HapisDakika] >= 1)
    hatamesaj(playerid, "Hapiste olduðun için komut kullanamazsýn, hapisin bitmesine %d kaldý.", OyuncuBilgileri[playerid][HapisDakika]);
    new skin;if(sscanf(params,"i",skin)) return kullanmesaj(playerid, "{3BEB5D}[!]{FFFFFF} /skin [skinid]");
    if(skin >= skin && skin < 300)
    {
        SetPlayerSkin(playerid,skin);
    } else return hatamesaj(playerid,"{3BEB5D}[!]{FFFFFF} Hatalý skin ID.");
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
  if(newstate == PLAYER_STATE_DRIVER)
    SetPlayerArmedWeapon(playerid, 0);
  if(newstate == PLAYER_STATE_PASSENGER)
  {
   if(GetPlayerWeapon(playerid) == 23 || GetPlayerWeapon(playerid) == 24 || GetPlayerWeapon(playerid) == 34)
   {

   SetPlayerArmedWeapon(playerid, 0);
   }
  }
  return 1;
}
public OnPlayerSpawn(playerid)
{

 if(OyuncuBilgileri[playerid][BALLASTEAM] == true || OyuncuBilgileri[playerid][GROVETEAM] == true || OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true || OyuncuBilgileri[playerid][HEADSHOTDM] == true || OyuncuBilgileri[playerid][FREEROAM] == true)
  {
  if(OyuncuBilgileri[playerid][LVPDDM] == true)
    {
     new sayi = random(8);
     sscanf(DMLVPDKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerInterior(playerid, 3);
     SetPlayerArmour(playerid, 40.0);
     SetPlayerVirtualWorld(playerid, 9);
     GivePlayerWeapon(playerid, 24, 500);
     GivePlayerWeapon(playerid, 25, 500);
    }

  if(OyuncuBilgileri[playerid][RCDM] == true)
    {
     new sayi = random(8);
     sscanf(DMRCBATTLEKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerInterior(playerid, 10);
     SetPlayerArmour(playerid, 40.0);
     SetPlayerVirtualWorld(playerid, 9);
     GivePlayerWeapon(playerid, 24, 500);
     GivePlayerWeapon(playerid, 25, 500);
     GivePlayerWeapon(playerid, 31, 500);
     GivePlayerWeapon(playerid, 34, 25);
    }
  if(OyuncuBilgileri[playerid][CITYDM] == true)
    {
     new sayi = random(8);
     sscanf(DMLIBERTCITYKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerInterior(playerid, 1);
     SetPlayerVirtualWorld(playerid, 9);
     GivePlayerWeapon(playerid, 24, 500);
     SetPlayerArmour(playerid, 40.0);
     GivePlayerWeapon(playerid, 25, 500);
     GivePlayerWeapon(playerid, 31, 500);
    }
    if(OyuncuBilgileri[playerid][WAREHOUSEDM] == true)
    {
     new sayi = random(8);
     sscanf(DMWAREHOUSEKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerInterior(playerid, 1);
     SetPlayerArmour(playerid, 40.0);
     SetPlayerVirtualWorld(playerid, 9);
     GivePlayerWeapon(playerid, 24, 500);
     GivePlayerWeapon(playerid, 25, 500);
     GivePlayerWeapon(playerid, 31, 500);
    }
    if(OyuncuBilgileri[playerid][HEADSHOTDM] == true)
    {
     new sayi = random(8);
     sscanf(HeadshotArenaKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
     SetPlayerInterior(playerid, 18);
     SetPlayerVirtualWorld(playerid, 9);
     GivePlayerWeapon(playerid, 24, 500);
    }
    if(OyuncuBilgileri[playerid][BALLASTEAM] == true)
    {
        SetPlayerColor(playerid,0x800080FF);
        SetPlayerPos(playerid,2459.2349,-1331.4287,24.0000);
        SetPlayerInterior(playerid, 0);
        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 40.0);
        SetPlayerVirtualWorld(playerid, 0);
        GivePlayerWeapon(playerid, 24, 500);
        GivePlayerWeapon(playerid, 25, 500);
        GivePlayerWeapon(playerid, 30, 500);
    }
 if(OyuncuBilgileri[playerid][GROVETEAM] == true)
    {
    // hopyavrum123
        new sayi = random(8);
        sscanf(FDMRANDKONUM(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
        SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
        SetPlayerInterior(playerid, 0);
        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 50.0);
        SetPlayerVirtualWorld(playerid, 0);
        GivePlayerWeapon(playerid, 24, 200);
        GivePlayerWeapon(playerid, 30, 250);
    }
    if(OyuncuBilgileri[playerid][FREEROAM] == true)
    {
      GivePlayerWeapon(playerid, 24, 500);
      SetPlayerPos(playerid, 1129.31, -1490.00, 22.77);
      SetPlayerInterior(playerid, 0);
      SetPlayerVirtualWorld(playerid, 31214);
    }
  }
  else
  {
    SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
    SetPlayerSkin(playerid, 20003);
    SetPlayerFacingAngle(playerid, OyuncuBilgileri[playerid][Pos][3]);
    SetCameraBehindPlayer(playerid);
    LobiyeDon(playerid);

    if(OyuncuBilgileri[playerid][GirisYapti] == 0) return 0;
  }
  TextDrawShowForPlayer(playerid, Fpsxd[playerid]);
  return true;
}


public OnPlayerUpdate(playerid)
{
new String[128];
new FPSSS = GetPlayerDrunkLevel(playerid), fps; if (FPSSS < 100) { SetPlayerDrunkLevel(playerid, 2000); } else { if (FPSSS != FPSS[playerid]) { fps = FPSS[playerid] - FPSSS; if (fps > 0 && fps < 200) FPS[playerid] = fps; FPSS[playerid] = FPSSS; } }
format(String, sizeof(String), "~b~~h~~h~Fps: ~w~%d ~y~- ~b~~h~~h~Ping: ~w~%d",FPS[playerid], GetPlayerPing(playerid));
TextDrawSetString(Fpsxd[playerid], String);

if(GetTickCount() - armedbody_pTick[playerid] > 113){ //prefix check itter
                new
                        weaponid[13],weaponammo[13],pArmedWeapon;
                pArmedWeapon = GetPlayerWeapon(playerid);
                GetPlayerWeaponData(playerid,1,weaponid[1],weaponammo[1]);
                GetPlayerWeaponData(playerid,2,weaponid[2],weaponammo[2]);
                GetPlayerWeaponData(playerid,4,weaponid[4],weaponammo[4]);
                GetPlayerWeaponData(playerid,5,weaponid[5],weaponammo[5]);
               #if ARMEDBODY_USE_HEAVY_WEAPON
                GetPlayerWeaponData(playerid,7,weaponid[7],weaponammo[7]);
               #endif
                if(weaponid[1] && weaponammo[1] > 0){
                        if(pArmedWeapon != weaponid[1]){
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,0)){
                                        SetPlayerAttachedObject(playerid,0,GetWeaponModel(weaponid[1]),1, 0.199999, -0.139999, 0.030000, 0.500007, -115.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                                }
                        }
                        else {
                                if(IsPlayerAttachedObjectSlotUsed(playerid,0)){
                                        RemovePlayerAttachedObject(playerid,0);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,0)){
                        RemovePlayerAttachedObject(playerid,0);
                }
                if(weaponid[2] && weaponammo[2] > 0){
                        if(pArmedWeapon != weaponid[2]){
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,1)){
                                        SetPlayerAttachedObject(playerid,1,GetWeaponModel(weaponid[2]),8, -0.079999, -0.039999, 0.109999, -90.100006, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                                }
                        }
                        else {
                                if(IsPlayerAttachedObjectSlotUsed(playerid,1)){
                                        RemovePlayerAttachedObject(playerid,1);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,1)){
                        RemovePlayerAttachedObject(playerid,1);
                }
                if(weaponid[4] && weaponammo[4] > 0){
                        if(pArmedWeapon != weaponid[4]){
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,2)){
                                        SetPlayerAttachedObject(playerid,2,GetWeaponModel(weaponid[4]),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                                }
                        }
                        else {
                                if(IsPlayerAttachedObjectSlotUsed(playerid,2)){
                                        RemovePlayerAttachedObject(playerid,2);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,2)){
                        RemovePlayerAttachedObject(playerid,2);
                }
                if(weaponid[5] && weaponammo[5] > 0){
                        if(pArmedWeapon != weaponid[5]){
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,3)){
                                        SetPlayerAttachedObject(playerid,3,GetWeaponModel(weaponid[5]),1, 0.200000, -0.119999, -0.059999, 0.000000, 206.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                                }
                        }
                        else {
                                if(IsPlayerAttachedObjectSlotUsed(playerid,3)){
                                        RemovePlayerAttachedObject(playerid,3);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,3)){
                        RemovePlayerAttachedObject(playerid,3);
                }
               #if ARMEDBODY_USE_HEAVY_WEAPON
                if(weaponid[7] && weaponammo[7] > 0){
                        if(pArmedWeapon != weaponid[7]){
                                if(!IsPlayerAttachedObjectSlotUsed(playerid,4)){
                                        SetPlayerAttachedObject(playerid,4,GetWeaponModel(weaponid[7]),1,-0.100000, 0.000000, -0.100000, 84.399932, 112.000000, 10.000000, 1.099999, 1.000000, 1.000000);
                                }
                        }
                        else {
                                if(IsPlayerAttachedObjectSlotUsed(playerid,4)){
                                        RemovePlayerAttachedObject(playerid,4);
                                }
                        }
                }
                else if(IsPlayerAttachedObjectSlotUsed(playerid,4)){
                        RemovePlayerAttachedObject(playerid,4);
                }
               #endif
                armedbody_pTick[playerid] = GetTickCount();
        }
        return 1;
}
forward YasakKontrol(playerid);
public YasakKontrol(playerid)
{
  new sorgu[150];
  if(cache_num_rows())
    {
      new mesaj[500], mesajstr[500], yasaklanan[MAX_PLAYER_NAME], yasaklayan[MAX_PLAYER_NAME], sebep[25], bitis, islemtarih;
      cache_get_value(0, "yasaklanan", yasaklanan, MAX_PLAYER_NAME);
    cache_get_value(0, "yasaklayan", yasaklayan, MAX_PLAYER_NAME);
      cache_get_value(0, "sebep", sebep, MAX_PLAYER_NAME);
    cache_get_value_int(0, "bitis", bitis);
    cache_get_value_int(0, "islemtarih", islemtarih);
    if(bitis == 0)
      {
      format(mesaj, sizeof(mesaj), "\n"#SUNUCU_RENK2"Süresiz yasaklandýn, yanlýþ olduðunu düþünüyorsanýz '"#BEYAZ2"discord"#SUNUCU_RENK2"' adresinde #probation kanalý üzerinden yöneticilere bildirin.");
      strcat(mesajstr, mesaj);
      format(mesaj, sizeof(mesaj), "\n\n"#SUNUCU_RENK2"Yasaklayan: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s", yasaklayan, sebep, Tarih(islemtarih));
      strcat(mesajstr, mesaj);
      ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_MSGBOX, "MG-DM", mesajstr, "Kapat", "");
      return Kickle(playerid);
    }
    if(bitis > gettime())
    {
      format(mesaj, sizeof(mesaj), "\n"#SUNUCU_RENK2"Yasaklandýn, yanlýþ olduðunu düþünüyorsanýz '"#BEYAZ2"discord"#SUNUCU_RENK2"' adresinde #probation kanalý üzerinden yöneticilere bildirin.");
      strcat(mesajstr, mesaj);
      format(mesaj, sizeof(mesaj), "\n\n"#SUNUCU_RENK2"Yasaklayan: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Bitiþ Tarihi: "#BEYAZ2"%s", yasaklayan, sebep, Tarih(islemtarih), Tarih(bitis));
      strcat(mesajstr, mesaj);
      ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_MSGBOX, "MG-DM", mesajstr, "Kapat", "");
      return Kickle(playerid);
    }
    else
    {
      mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "DELETE FROM yasaklar WHERE yasaklanan = '%s'", yasaklanan);
      mysql_tquery(alomitymerdsql, sorgu, "", "");
      mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "SELECT * FROM hesaplar WHERE isim = '%s'", OyuncuAdiGetir(playerid));
      mysql_tquery(alomitymerdsql, sorgu, "OyuncuKontrol", "dd", playerid);
    }
  }
  else
  {
    mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "SELECT * FROM hesaplar WHERE isim = '%s'", OyuncuAdiGetir(playerid));
    mysql_tquery(alomitymerdsql, sorgu, "OyuncuKontrol", "dd", playerid);
  }
  return 1;
}

public OnPlayerConnect(playerid)
{

   EkranTemizle(playerid);
   PlayAudioStreamForPlayer(playerid,"https://stt.jisiss.is/202cfd4e035d6b724aa8a65f5e0d5bdd/2-ZBiJdVYBY/croveievcrivic");
   Fpsxd[playerid] = TextDrawCreate(569.882446, 1.749999, "~b~~h~~h~FPS: ~w~100 ~b~~h~~h~PING: ~w~10000");
   TextDrawLetterSize(Fpsxd[playerid], 0.155882, 1.034166);
   TextDrawAlignment(Fpsxd[playerid], 1);
   TextDrawColor(Fpsxd[playerid], -1);
   TextDrawSetShadow(Fpsxd[playerid], 0);
   TextDrawSetOutline(Fpsxd[playerid], 1);
   TextDrawBackgroundColor(Fpsxd[playerid], 51);
   TextDrawFont(Fpsxd[playerid], 2);
   TextDrawSetProportional(Fpsxd[playerid], 1);
    SetPVarInt(playerid, "GodMode", 0);


  new sorgu[200], ipadresi[16];
  GetPlayerIp(playerid, ipadresi, 16);
  mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "SELECT * FROM yasaklar WHERE yasaklanan = '%s' OR yasakip = '%s'", OyuncuAdiGetir(playerid), ipadresi);
  mysql_tquery(alomitymerdsql, sorgu, "YasakKontrol", "d", playerid);


   PlayerIDTemizle( playerid );
   new query[256];
   mysql_format(alomitymerdsql, query, sizeof query, "SELECT * FROM `oyuncular` WHERE `isim` = '%s'", OyuncuAdiGetir(playerid));
   mysql_tquery(alomitymerdsql, query, "OyuncuKontrol", "i",playerid);

  new string[50 + MAX_PLAYER_NAME],playerName[MAX_PLAYER_NAME];

  GetPlayerName(playerid, playerName, sizeof(playerName));

  if (giris_cikis) {
      format(string, sizeof(string), "``[CONNECTION] %s adli oyuncu sunucuya baglandi.``", playerName);
      DCC_SendChannelMessage(giris_cikis, string);
  }
  return true;
}


public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{


  return true;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
 new animtusu = KEY_FIRE, egilmetusu = KEY_CROUCH;
 if(!OyuncuBilgileri[playerid][Cbug] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
  {
    if(PRESSED(animtusu))
    {
      switch(GetPlayerWeapon(playerid))
      {
        case WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SNIPER:
        {
          OyuncuBilgileri[playerid][CbugSilah] = gettime();
        }
      }
    }
    else if(PRESSED(egilmetusu))
    {
      if((gettime() - OyuncuBilgileri[playerid][CbugSilah]) < 1)
      {
        TogglePlayerControllable(playerid, false);
        OyuncuBilgileri[playerid][Cbug] = true;
        GameTextForPlayer(playerid, "~r~C-BUG YASAK!", 3000, 4);
        adminmesaj(1, 0xEE1616FF, "YONETIM: %s adlý oyuncu CBUG yapýyor!", OyuncuAdiGetir(playerid));
        KillTimer(OyuncuBilgileri[playerid][CbugTimer]);
        OyuncuBilgileri[playerid][CbugTimer] = SetTimerEx("CBugFreeze", TIMER_SANIYE_BUCUK(1), false, "d", playerid);
        new string[50 + MAX_PLAYER_NAME],playerName[MAX_PLAYER_NAME];

        GetPlayerName(playerid, playerName, sizeof(playerName));

        format(string, sizeof(string), "``[CBUG] %s adli oyuncu CBUG yapmaya calisiyor.``", playerName);
        DCC_SendChannelMessage(yonetim, string);

      }
    }
  }
  if (newkeys & KEY_FIRE && GetPlayerTargetActor(playerid) == tdmactor)
    {
            new string[500], toplamoyuncu[1024];
        strcat(string, " \n");
           format(toplamoyuncu, sizeof(toplamoyuncu), "{EEDD82}»{FFFFFF} Grove Team (0/10)\n");
        strcat(string, toplamoyuncu);
        format(toplamoyuncu, sizeof(toplamoyuncu), "{EEDD82}»{FFFFFF} Ballas Team (0/10)\n");
        strcat(string, toplamoyuncu);
         ShowPlayerDialog (playerid, DIALOG_TDM, DIALOG_STYLE_TABLIST_HEADERS, "Deathmatch Arena", string, "Join", "Cancel");
    OyuncuBilgileri[playerid][LOBI] = false;
    }
  if (newkeys & KEY_FIRE && GetPlayerTargetActor(playerid) == dmactor)
    {
       new string[500], toplamoyuncu[1024];
        strcat(string, " \n");
           format(toplamoyuncu, sizeof(toplamoyuncu), "{EEDD82}»{FFFFFF} LVPD Arena (%d/10)\n", LVPDDMsayi);
        strcat(string, toplamoyuncu);
        format(toplamoyuncu, sizeof(toplamoyuncu), "{EEDD82}»{FFFFFF} Libertty City Inside (%d/10)\n", CITYDMsayi);
        strcat(string, toplamoyuncu);
        format(toplamoyuncu, sizeof(toplamoyuncu), "{EEDD82}»{FFFFFF} RC Battlefield (%d/10)\n", RCDMsayi);
        strcat(string, toplamoyuncu);
        format(toplamoyuncu, sizeof(toplamoyuncu), "{EEDD82}»{FFFFFF} Warehouse (%d/10)\n", WAREHOUSEDMsayi);
        strcat(string, toplamoyuncu);
        format(toplamoyuncu, sizeof(toplamoyuncu), "{EEDD82}»{FFFFFF} Headshot Arena (0/10)\n", HEADSHOTDMsayi);
        strcat(string, toplamoyuncu);
         ShowPlayerDialog (playerid, DIALOG_DMLOBILERI, DIALOG_STYLE_TABLIST_HEADERS, "Deathmatch Arena", string, "Join", "Cancel");
        OyuncuBilgileri[playerid][LOBI] = false;
    }
    if (newkeys & KEY_FIRE && GetPlayerTargetActor(playerid) == freeroamactor)
    {
       if(OyuncuBilgileri[playerid][HapisDakika] >= 1)
  hatamesaj(playerid, "Hapiste olduðun için komut kullanamazsýn, hapisin bitmesine %d kaldý.", OyuncuBilgileri[playerid][HapisDakika]);
  if(OyuncuBilgileri[playerid][BALLASTEAM] == true || OyuncuBilgileri[playerid][GROVETEAM] == true || OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true || OyuncuBilgileri[playerid][HEADSHOTDM] == true || OyuncuBilgileri[playerid][ADM] == true)
  return hatamesaj(playerid, "Þuan lobilere katýlamazsýn! (zaten lobilerden birindesiniz)");
  OyuncuBilgileri[playerid][FREEROAM] = true;
  SetPlayerPos(playerid, 1129.31, -1490.00, 22.77);
  SetPlayerInterior(playerid, 0);
  SetPlayerVirtualWorld(playerid, 0);
  OyuncuBilgileri[playerid][LOBI] = false;
    }



  return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
  for(new i; i < MAX_PLAYERS; i++)
  {
    if(Reportlar[i][sGonderen1] == playerid)
    {
      Reportlar[i][acildiMi1] = 0;
      Reportlar[i][sGonderen1] = INVALID_PLAYER_ID;
      Reportlar[i][sSuclu] = INVALID_PLAYER_ID;
      format(Reportlar[i][_url1], 148, "");
      }
  }
  KillTimer(OyuncuBilgileri[playerid][CbugTimer]);
  if(OyuncuBilgileri[playerid][HapisDakika] >= 1) KillTimer(OyuncuBilgileri[playerid][HapisTimer]);
  if(OyuncuBilgileri[playerid][SusturDakika] >= 1) KillTimer(OyuncuBilgileri[playerid][SusturTimer]);

  OyuncuGuncelle(playerid);
  TextDrawHideForPlayer(playerid, Fpsxd[playerid]);
  if (!IsPlayerNPC(playerid))
         {
           new sebep[30];
           switch (reason)
           {
            case 0: sebep = "zaman asimi/crash";
            case 1: sebep = "kendi istegiyle";
            case 2: sebep = "kicklendi/banlandi";
            default: sebep = "Bilinmiyor";
           }
           YollaHerkeseMesaj(0xAFAFAFFF, "%s sunucudan ayrildi. (%s)", OyuncuAdiGetir(playerid), sebep);
           printf("%s sunucudan ayrildi. (%s)", OyuncuAdiGetir(playerid), sebep);
         }
          DeletePVar(playerid, "GodMode");

            if (DMOda[playerid] == 0) return LVPDDMsayi--;
  if (DMOda[playerid] == 1) return CITYDMsayi--;
  if (DMOda[playerid] == 2) return RCDMsayi--;
  if (DMOda[playerid] == 3) return WAREHOUSEDMsayi--;
  if (DMOda[playerid] == 4) return HEADSHOTDMsayi--;
          return true;


}


function OyuncuKontrol(playerid)
{
  new rows, fields,string[256];
  cache_get_row_count(rows);
  cache_get_field_count(fields);
  if(rows)
  {
    EkranTemizle( playerid );
    KameraBakis(playerid);
    format(string,sizeof(string),"Merhaba %s lütfen giriþ yapmak için þifrenizi giriniz.",OyuncuAdiGetir(playerid));
  ShowPlayerDialog(playerid, DIALOG_GIRIS, DIALOG_STYLE_PASSWORD, "Magenta Deatmatch's - Giriþ", string, "Giriþ Yap", "Çýkýþ Yap");
  new guncelle[256];
  format(guncelle, sizeof(guncelle), "UPDATE oyuncular SET `songiris`='%s', `IP` ='%s' WHERE `isim`='%s'",TarihGetir(),IPGetir(playerid),OyuncuAdiGetir(playerid));
    mysql_query(alomitymerdsql,guncelle,false);
  }
  else
  {
    EkranTemizle( playerid );
    KameraBakis(playerid);
  format(string,sizeof(string),"Merhaba %s veritabanýnda kaydýnýz bulunamadý lütfen kayýt olmak için þifrenizi girin.",OyuncuAdiGetir(playerid));
  ShowPlayerDialog(playerid, DIALOG_KAYIT, DIALOG_STYLE_PASSWORD, "Magenta Deatmatch's - Yeni Kayýt", string, "Kayýt Ol", "Çýkýþ Yap");
  }
  return true;
}

stock OyuncuAdiGetir(playerid)
{
  new name[ MAX_PLAYER_NAME + 1 ];
  GetPlayerName(playerid, name, sizeof( name ) );
  return name;
}
stock GetWeaponModel(weaponid)
{
        switch(weaponid)
        {
            case 1:
                return 331;

                case 2..8:
                    return weaponid+331;

        case 9:
                    return 341;

                case 10..15:
                        return weaponid+311;

                case 16..18:
                    return weaponid+326;

                case 22..29:
                    return weaponid+324;

                case 30,31:
                    return weaponid+325;

                case 32:
                    return 372;

                case 33..45:
                    return weaponid+324;

                case 46:
                    return 371;
        }
        return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    for(new i; i < sizeof(antisqlinjection); i++)
  {
      if(strfind(inputtext, antisqlinjection[i], true) != -1)
    {
       SendClientMessage(playerid,-1, "{00ff00}[!]{ffffff} Özel karakter kullanmak yasaktýr.");
       return 0;
    }
  }
    switch ( dialogid )
    {
     case DIALOG_KAYIT:
     {
     if(!response) return Kick(playerid);
     if(response)
     {
             new hash[65],kaydet[256],sabitsalt[20];
             SHA256_PassHash(inputtext, sabitsalt, hash, 64);
       mysql_format(alomitymerdsql, kaydet, sizeof(kaydet), "INSERT INTO oyuncular (isim, sifre,songiris,IP,skor,kiyafet,para,oldurme,olme) VALUES ('%s','%e','%s','%s','1', '1','1000','0','0')", OyuncuAdiGetir(playerid),hash,TarihGetir(),IPGetir(playerid));
             mysql_query(alomitymerdsql, kaydet,false);
       SendClientMessage(playerid,-1,"{00ff00}[!]{ffffff} Kayýt iþlemi baþarýlý þifreni yazarak giriþ yapabilirsin.");
         ShowPlayerDialog(playerid, DIALOG_GIRIS, DIALOG_STYLE_PASSWORD, "Magenta Deatmatch's - Ilk Giriþ", "Lütfen biraz önce oluþturmuþ olduðunuz þifrenizi girin.", "Giriþ Yap", "Çýkýþ Yap");
     }
     return true;
     }
     case DIALOG_GIRIS:
     {
       if(!response) return Kick(playerid);
       if(response)
       {
        new hash[65],sorgu[256],sabitsalt[20];
                SHA256_PassHash(inputtext, sabitsalt, hash, 64);
                if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_GIRIS, DIALOG_STYLE_PASSWORD, "Magenta Deatmatch Giriþ", "þifre alaný boþ býrakýlamaz.", "Giriþ Yap", "Çýkýþ Yap");
        mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "SELECT * FROM `oyuncular` WHERE `isim`='%e' AND `sifre`='%s'", OyuncuAdiGetir(playerid), hash);
        mysql_tquery(alomitymerdsql, sorgu, "GirisKontrol", "i", playerid);
       }
       return true;
     }
    }
    if(dialogid == DIALOG_DMLOBILERI)
     {
     if(response)
     {
      if(listitem == 0)
      {
         new lvpdsayi = 0;
         if(OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true)
         return hatamesaj(playerid, "Zaten DM lobisindesin.");
         new sayi = random(8);
         sscanf(DMLVPDKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         OyuncuBilgileri[playerid][LVPDDM] = true;
         OyuncuBilgileri[playerid][LOBI] = false;
         SetPlayerInterior(playerid, 3);
         SetPlayerSkin(playerid, 20003);
         SetPlayerHealth(playerid, 100.0);
         SetPlayerArmour(playerid, 40.0);
         SetPlayerVirtualWorld(playerid, 9);
         GivePlayerWeapon(playerid, 24, 500);
         GivePlayerWeapon(playerid, 25, 500);
         DMOda[playerid] = 0;
         LVPDDMsayi++;

        foreach(new i : Player)
        {
          if(OyuncuBilgileri[i][LVPDDM] == true)
           {
            bilgimesaj(i, "ARENA: Bir oyuncu LVPD DM adlý arenaya katýldý!");
           }
        }
         SetPVarInt(playerid, "GodMode", 0);
      }
        if(listitem == 1)
       {
         if(OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true)
         return hatamesaj(playerid, "Zaten DM lobisindesin.");
         new sayi = random(8);
         sscanf(DMLIBERTCITYKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         OyuncuBilgileri[playerid][CITYDM] = true;
         OyuncuBilgileri[playerid][LOBI] = false;
         SetPlayerInterior(playerid, 1);
         SetPlayerSkin(playerid, 20003);
         SetPlayerHealth(playerid, 100.0);
         SetPlayerArmour(playerid, 40.0);
         SetPlayerVirtualWorld(playerid, 9);
         GivePlayerWeapon(playerid, 24, 500);
         GivePlayerWeapon(playerid, 25, 500);
         GivePlayerWeapon(playerid, 30, 500);
         SetPVarInt(playerid, "GodMode", 0);
         DMOda[playerid] = 1;
         CITYDMsayi++;
        foreach(new i : Player)
        {
          if(OyuncuBilgileri[i][CITYDM] == true)
           {
            bilgimesaj(i, "ARENA: Bir oyuncu Liberty City DM adlý arenaya katýldý!");
           }
        }
       }
      if(listitem == 2)
       {

         if(OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true)
         return hatamesaj(playerid, "Zaten DM lobisindesin.");
         new sayi = random(8);
         sscanf(DMRCBATTLEKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         OyuncuBilgileri[playerid][RCDM] = true;
         OyuncuBilgileri[playerid][LOBI] = false;
         SetPlayerInterior(playerid, 10);
         SetPlayerSkin(playerid, 20003);
         SetPlayerHealth(playerid, 100.0);
         SetPlayerArmour(playerid, 40.0);
         SetPlayerVirtualWorld(playerid, 9);
         GivePlayerWeapon(playerid, 24, 500);
         GivePlayerWeapon(playerid, 25, 500);
         GivePlayerWeapon(playerid, 31, 500);
         GivePlayerWeapon(playerid, 34, 25);
         SetPVarInt(playerid, "GodMode", 0);
         foreach(new i : Player)
        {
          if(OyuncuBilgileri[i][RCDM] == true)
           {
            bilgimesaj(i, "ARENA: Bir oyuncu RC Ground DM adlý arenaya katýldý!");
           }
        }
        DMOda[playerid] = 2;
        RCDMsayi++;

       }
      if(listitem == 3)
       {

         if(OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true)
         return hatamesaj(playerid, "Zaten DM lobisindesin.");
         new sayi = random(8);
         sscanf(DMWAREHOUSEKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         OyuncuBilgileri[playerid][WAREHOUSEDM] = true;
         OyuncuBilgileri[playerid][LOBI] = false;
         SetPlayerInterior(playerid, 1);
         SetPlayerSkin(playerid, 20003);
         SetPlayerHealth(playerid, 100.0);
         SetPlayerArmour(playerid, 40.0);
         SetPlayerVirtualWorld(playerid, 9);
         GivePlayerWeapon(playerid, 24, 500);
         GivePlayerWeapon(playerid, 25, 500);
         GivePlayerWeapon(playerid, 31, 500);
         GivePlayerWeapon(playerid, 34, 25);
         SetPVarInt(playerid, "GodMode", 0);
         foreach(new i : Player)
        {
          if(OyuncuBilgileri[i][WAREHOUSEDM] == true)
           {
            bilgimesaj(i, "ARENA: Bir oyuncu Warehouse DM adlý arenaya katýldý!");
           }
        }
         DMOda[playerid] = 3;
         WAREHOUSEDMsayi++;
       }
       if(listitem == 4)
       {

         if(OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true)
         return hatamesaj(playerid, "Zaten DM lobisindesin.");
         new sayi = random(8);
         sscanf(HeadshotArenaKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
         OyuncuBilgileri[playerid][HEADSHOTDM] = true;
         OyuncuBilgileri[playerid][LOBI] = false;
         SetPlayerInterior(playerid, 18);
         SetPlayerSkin(playerid, 20003);
         SetPlayerHealth(playerid, 100.0);
         SetPlayerVirtualWorld(playerid, 9);
         GivePlayerWeapon(playerid, 24, 500);
         GivePlayerWeapon(playerid, 34, 150);
         SetPVarInt(playerid, "GodMode", 0);
         foreach(new i : Player)
        {
          if(OyuncuBilgileri[i][HEADSHOTDM] == true)
           {
            bilgimesaj(i, "ARENA: Bir oyuncu Headshot DM adlý arenaya katýldý!");
           }
        }
         DMOda[playerid] = 4;
         HEADSHOTDMsayi++;
       }
   }
   }

    if(dialogid == DIALOG_WEAPS)
   {
    if(response)
     {
      if(listitem == 1)
      {
      if(GetPlayerMoney(playerid) < 15000) return hatamesaj(playerid, "Sniper alabilmek için 15000$'ýnýzýn olmasý lazým!");
      GivePlayerWeapon(playerid, 34, 50);
      ParaVer(playerid, -2500);
      GameTextForPlayer(playerid, "~w~Sniper Aldiniz, ~r~-15000$", 2500,1);
      return 1;
      }
      if(listitem == 2)
      {
      if(GetPlayerMoney(playerid) < 5000) return hatamesaj(playerid, "M4 alabilmek için 5000$'ýnýzýn olmasý lazým!");
      GivePlayerWeapon(playerid, 31, 250);
      ParaVer(playerid, -5000);
      GameTextForPlayer(playerid, "~w~M4 Aldiniz, ~r~-5000$", 2500,1);
      return 1;
      }
     }
   }
     if(dialogid == DIALOG_YARDIM)
     {
      if(response)
      {
        if(listitem == 0)
        {
          ShowPlayerDialog(playerid, DIALOG_YARDIM, DIALOG_STYLE_MSGBOX, "TDM KOMUTLARI", "/tdm - TDM'ye bu komutla girebilirsin.\n/market - TDM'de iken bu komut ile armor ve silah alabilirsin.", "Çýk");
        }
        if(listitem == 1)
        {
          ShowPlayerDialog(playerid, DIALOG_YARDIM, DIALOG_STYLE_MSGBOX, "DM KOMUTLARI", "/dm - DM'ye bu komutla girebilirsin.\n", "Çýk");
        }
        if(listitem == 2)
        {
          ShowPlayerDialog(playerid, DIALOG_YARDIM, DIALOG_STYLE_MSGBOX, "FREEROAM KOMUTLARI", "/freeraom - Freeraom'a bu komutla girebilirsin.\n/goto - komudu ile freeroamda bulunan oyunculara teleport olabilirsiniz.\n/mytime - komudu ile saatinizi ayarlayabilirsiniz.\n/myweather - komudu ile havayý deðiþtirebilirsiniz.\n/nos - komudu ile aracýnýza nitro takabilirsiniz.\n/vehcolor - komudu ile araç rengini deðiþtirebilirsiniz.\n/veh - komudu ile araç getirebilirsiniz.\n/health - komudu ile can alabilirsin.\n/armor - komudu ile armor alabilirsin.\n/wep - komudu ile silah alabilirsin.\n/flip - komudu ile ters dönen aracýnýzý düzeltebilirsiniz.\n/world - komudu ile virtualworld'ünüzü deðiþtirebilirsiniz.\n/repair - komudu ile aracýnýzý fixleyebilirsiniz.\n/jetpack - komudu ile jetpack alabilirsiniz.\n/vgod - komudu ile aracýnýzý hasar almaz yapabilirsiniz.\n/god - komudu ile ölümsüz olabilirsin.", "Çýk");
        }
        if(listitem == 3)
        {
          ShowPlayerDialog(playerid, DIALOG_YARDIM, DIALOG_STYLE_MSGBOX, "GENEL KOMUTLAR", "/animlist - komudu ile animlere bakabilirsin.\n/vwbak - komudu ile  virtualworld ve interior ID'nize bakabilirsiniz.\n/sorusor - komudu ile bilmediðiniz þeyleri sorabilirsiniz.\n/skinidim - komudu ile skin ID'nize bakabilirsiniz.\n/muzikkapat ile açýlan müziði kapatabilirsiniz.\n/skin - komudu ile skini'nizi deðiþtirebilirsiniz.\n/report komudu ile þüphelendiðiniz kiþileri rapor edebilirsiniz.\n/topskor - komudu ile top 10 skor'a bakabilirsiniz.\n/topdm - komudu ile top 10 öldürmeye bakabilirsin.\n/credits - komudu ile yapýmcýlara bakabilirsin.\n/id - komudu ile ismini girdiðiniz kiþinin bilgilerini görebilirsiniz.\n/admins - komudu ile aktif adminlere bakabilirsiniz\n/cw komudu ile araç içerisindeki kiþiler ile konuþabilirsiniz.\n/pm - komudu ile kiþilere pm atabilirsiniz.\n/pmkapat - komudu ile pm alýmlarýný kapatabilirsiniz.\n/bilgilerim - komudu ile bilgilerinizi görebilirsiniz.\n/lobi komudu ile lobiye dönebilirsiniz.", "Çýk");
        }
      }
     }
switch (dialogid)
  {
    case REPORTLAR:
      {
          if(response)
          {
        new sz[15], c;
        format(sz, sizeof(sz), "sarkiID_%d", listitem);
        c = GetPVarInt(playerid, sz);
        if(Reportlar[c][acildiMi1] == 0) return hatamesaj(playerid, "Bu kullanýcýnýn reportuna bakýlmýþ.");
              SetPVarInt(playerid, "sarkicID", listitem);
              ShowPlayerDialog(playerid, REPORT_YANIT, DIALOG_STYLE_MSGBOX, "{FFFFFF}Report", "{FFCF4B}Bu kullanýcýnýn þikayetine bakýldý mý ?\n{FFCF4B}Eðer \"Bakýldý\" butonuna basarsanýz bu þikayet listeden otomatik olarak silinecektir.\n{FFCF4B}Report sile basarsan bu þikayet kaldýrýlacaktýr.", "Bakýldý", "Reportu Sil");
          }
      }

      case REPORT_YANIT:
      {
      if(!response)
         {
        new sz[15], c;
        format(sz, sizeof(sz), "sarkiID_%d", GetPVarInt(playerid, "sarkicID"));
        c = GetPVarInt(playerid, sz);
        Reportlar[c][acildiMi1] = 0;
        Reportlar[c][sGonderen1] = INVALID_PLAYER_ID;
        Reportlar[c][sSuclu] = INVALID_PLAYER_ID;
        format(Reportlar[c][_url1], 148, "");
        bilgimesaj(playerid, "Report: Listeden kaldýrýldý.");
        foreach(new i : Player)
        {
            if(OyuncuBilgileri[i][adminlevel] >= 2)
            {
            adminmesaj(i, 0x6AB04CFF, "%s(%d), /reportlar komutundan bir þikayet kaldýrdý.", OyuncuAdiGetir(playerid), playerid);
            }
        }
          }
      if(response)
          {
           new sz[15], c, bb[400];
           format(sz, sizeof(sz), "sarkiID_%d", GetPVarInt(playerid, "sarkicID"));
           c = GetPVarInt(playerid, sz);
           if(Reportlar[c][acildiMi1] == 0) return hatamesaj(playerid, "Bu kullanýcýnýn þikayetine bakýlmýþ.");
           if(!IsPlayerConnected(Reportlar[c][sGonderen1]) || !IsPlayerConnected(Reportlar[c][sSuclu]))
          {
            Reportlar[c][acildiMi1] = 0;
            Reportlar[c][sGonderen1] = INVALID_PLAYER_ID;
            Reportlar[c][sSuclu] = INVALID_PLAYER_ID;
            format(Reportlar[c][_url1], 148, "");
            hatamesaj(playerid, "Bu kullanýcý veya þikayet edilen kiþi oyundan çýkmýþ.");
            return 1;
          }
            format(bb, sizeof(bb), "{f1c40f}Ilgilenen Yetkili: {FFFFFF}%s\n{f1c40f}Þikayetiniz: {ffffff}%s\n\n{ffffff}Þikayetiniz deðerlendiriliyor, Iyi oyunlar...", OyuncuAdiGetir(playerid), Reportlar[c][_url1]);
            ShowPlayerDialog(Reportlar[c][sGonderen1], 95959, DIALOG_STYLE_MSGBOX, "{FFFFFF}Þikayetiniz", bb, "Kapat", "");
            bilgimesaj(playerid,"Kullanýcýnýn þikayetine baktýnýz.");
            Reportlar[c][acildiMi1] = 0;
            Reportlar[c][sGonderen1] = INVALID_PLAYER_ID;
            Reportlar[c][sSuclu] = INVALID_PLAYER_ID;
            format(Reportlar[c][_url1], 148, "");
      }
    }
}
    return 0;
}
CMD:reportlar(playerid)
{
    if(OyuncuBilgileri[playerid][adminlevel] < 1) return hatamesaj(playerid, "Bu komutu kullanmak için 1 level admin olmalýsýn.");
  new sz[1024], xzc = 0, xzsc[15];
    format(sz, sizeof(sz), "{7A8AFF}#\t{7A8AFF}Gönderen\t{7A8AFF}Þikayet Edilen\t{7A8AFF}Þikayet\n");
  for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(Reportlar[i][acildiMi1] == 0) continue;
      format(xzsc, sizeof(xzsc), "sarkiID_%d", xzc);
      SetPVarInt(playerid, xzsc, i);
      xzc++;
      format(sz, sizeof(sz), "%s%d\t%s\t%s\t%s\n", sz, xzc, OyuncuAdiGetir(Reportlar[i][sGonderen1]), OyuncuAdiGetir(Reportlar[i][sSuclu]), Reportlar[i][_url1]);
    }
  if(xzc == 0) return ShowPlayerDialog(playerid, 85858, DIALOG_STYLE_MSGBOX, "{FFFFFF}Reportlar", "Þikayet bulunmamaktadýr.", "Kapat", "");
  if(xzc != 0) return ShowPlayerDialog(playerid, REPORTLAR, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Reportlar", sz, "Iþlem Yap", "Kapat");
  return 1;
}


CMD:report(playerid, params[])
{
  new s[100], m[148], id, idd;
  if(sscanf(params, "us[100]", id, s)) return kullanmesaj(playerid, "/report [ID] [Þikayetiniz]");
    if(!IsPlayerConnected(id)) return hatamesaj(playerid, "Sunucuda böyle bir ID yok !");
  if(playerid == id) return hatamesaj(playerid, "Kendini mi þikayet edeceksin ?");
  foreach(new i: Player)
  {
      format(m,sizeof(m),"[REPORT] Oyuncu %s(%d) yeni bir þikayette bulundu. /reportlar komutuyla bu þikayete bakabilirsiniz.", OyuncuAdiGetir(playerid), playerid);
      if(OyuncuBilgileri[i][adminlevel] >= 1) bilgimesaj(i,  m);
  }
  idd = report_bosID();
  Reportlar[idd][acildiMi1] = 1;
    Reportlar[idd][sGonderen1] = playerid;
    Reportlar[idd][sSuclu] = id;
    format(Reportlar[idd][_url1], 148, s);

  bilgimesaj(playerid, "Þikayetiniz yetkili adminlere ulaþtýrýldý.");
  return 1;
}
CMD:topskor(playerid)
{
    new query[200];

  new Cache:VeriCek;
  mysql_format(alomitymerdsql, query, sizeof(query), "SELECT * FROM `oyuncular` ORDER BY `skor` DESC, `isim` LIMIT 0, 10;");
  VeriCek = mysql_query(alomitymerdsql, query);
  new rows = cache_num_rows();
  if(rows)
  {
    new list[1024], IsimCek[24],count = 1,skorrr;
    format(list, sizeof(list), "{7A8AFF}#\t{7A8AFF}Isim\t{7A8AFF}Skor\n");
    for(new i = 0; i < rows; ++i)
    {
      cache_get_value_name(i, "isim", IsimCek);
      cache_get_value_name_int(i, "skor", skorrr);
      format(list,sizeof(list),"%s{FFFFFF}%d.\t{FFFFFF}%s\t{FFFFFF}%s\n", list, count, IsimCek, convertNumber(skorrr));
      count++;
    }
    ShowPlayerDialog(playerid, 95959, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Magenta DM - Top 10 Skor", list, "Kapat", "");
  }
  cache_delete(VeriCek);
  return 1;
}
/*CMD:topdm(playerid)
{
    new query[200];

  new Cache:VeriCek;
  mysql_format(alomitymerdsql, query, sizeof(query), "SELECT * FROM `oyuncular` ORDER BY `oldurme` DESC, `isim` LIMIT 0, 10;");
  VeriCek = mysql_query(alomitymerdsql, query);
  new rows = cache_num_rows();
  if(rows)
  {
    new list[1024], IsimCek[24],count = 1,skorrr;
    format(list, sizeof(list), "{7A8AFF}#\t{7A8AFF}Isim\t{7A8AFF}Öldürme\n");
    for(new i = 0; i < rows; ++i)
    {
      cache_get_value_name(i, "isim", IsimCek);
      cache_get_value_name_int(i, "oldurme", skorrr);
      format(list,sizeof(list),"%s{FFFFFF}%d.\t{FFFFFF}%s\t{00FF00}%s\n", list, count, IsimCek, convertNumber(skorrr));
      count++;
    }
    ShowPlayerDialog(playerid, 95959, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Top 10 - Öldürme", list, "Kapat", "");
  }
  cache_delete(VeriCek);
  return 1;
}*/
/*CMD:credits(playerid, params[])
{
  new ww[400];
  format(ww, sizeof(ww), "%s{FFFFFF}Sunucu Kurucularý:\t\t{E01931} merddz \n",ww);
  format(ww, sizeof(ww), "%s{FFFFFF}Web Site:\t\t\t{FC575E}\n", ww);
  format(ww, sizeof(ww), "%s{FFFFFF}Kuruluþ Tarihi:\t\t\t{3498DB}27.05.2021\n\n", ww);
  format(ww, sizeof(ww), "%s{80CDCD}Gamemode design and developing by {CDCDCD} merddz {80CDCD}.", ww);
  ShowPlayerDialog(playerid, 95959, DIALOG_STYLE_MSGBOX, "{F5AC89}Alomity ~ DM", ww, "Kapat", "");
  return 1;
}*/
/*CMD:mytime(playerid, params[])
{
  if(OyuncuBilgileri[playerid][FREEROAM] == false)
   return hatamesaj(playerid,"Freeroamda bulunmalýsýnýz.");
    new time;
    if(sscanf(params,"i", time)) return kullanmesaj(playerid, " /mytime (saat)");
    if(time < 0 || time > 24) return hatamesaj(playerid, "Saati 0 ile 24 arasý girebilirsiniz.");
    SetPlayerTime(playerid, time, 0);
    bilgimesaj(playerid, "Kendi oyun saatinizi deðiþtirdiniz.");
    return 1;
}

CMD:myweather(playerid, params[])
{
    if(OyuncuBilgileri[playerid][FREEROAM] == false)
   return hatamesaj(playerid,"Freeroamda bulunmalýsýnýz.");
    new weather;
    if(sscanf(params,"i", weather)) return kullanmesaj(playerid, "/myweather (Hava ID)");
    if(weather < 0 || weather > 50) return hatamesaj(playerid, "Hava ID`lerini 0 ile 50 arasý girebilirsiniz.");
    SetPlayerWeather(playerid, weather);
    bilgimesaj(playerid, "Kendi oyun havanýzý deðiþtirdiniz.");
    return 1;
}*/
CMD:id(playerid, params[])
{
 new cek = 0;
  if (isnull(params)) return kullanmesaj(playerid, "/ID (Isim)");
  foreach (new i : Player)
  {
      if (strfind(OyuncuAdiGetir(i), params, true) != -1)
      {
          bilgimesaj(playerid, "{FF0000}**{FFFFFF} %s{FFAA00} - {FFFFFF}ID: %d {FFAA00}- {FFFFFF}PING: %d {FFAA00}- {FFFFFF}FPS: %d {FF0000}**", OyuncuAdiGetir(i), i, GetPlayerPing(i), GetPlayerFPS(i));
          cek++;
    }
  }

 if (!cek) return hatamesaj(playerid,  "Eþleþen \"%s\" karakterinde bir kullanýcý bulunamadý.", params);
  return 1;
}
CMD:dcbildiri(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] >= 1)
  {
    new sebep[240], str[240];
      if(sscanf(params, "s[240]", sebep))
        return kullanmesaj(playerid, "/dcbildiri [oyuncu isim, ceza, sebep]");

      adminmesaj(1, 0x008000FF, "%s adlý admin discorda not býraktý.", OyuncuAdiGetir(playerid));
      format(str, sizeof str, "[NOT] %s | %s, [%s] ", TRcevir(sebep), TRcevir("yönetici tarafýndan not býrakýldý"), OyuncuAdiGetir(playerid));
    DCC_SendChannelMessage(dcbildiri, str);
  }
  return 1;
}
CMD:admins(playerid, params[])
{

  new aktifyonetici = 0;
  foreach(new i : Player)
  {
    if(OyuncuBilgileri[i][adminlevel] >= 1)
    {
      bilgimesaj(playerid, "[%s] %s", YoneticiYetkiAdi(OyuncuBilgileri[i][adminlevel]), OyuncuAdiGetir(i));
      aktifyonetici++;
    }
  }
  if(aktifyonetici == 0)
    return hatamesaj(playerid, "Çevrimiçi yönetici yok.");
  return 1;
}
static const WeapSlot[] =
{
  0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
  10, 10, 10, 10, 10, 10, 8, 8,
  8, -1, -1, -1, 2, 2, 2, 3, 3,
  3, 4, 4, 5, 5, 4, 6, 6, 7, 7,
  7, 7, 8, 12, 9, 9, 9, 11, 11, 11
};

static const WeaponNames[55][] =
{
  {"Punch"}, {"Brass Knuckles"}, {"Golf Club"}, {"Nite Stick"}, {"Knife"}, {"Baseball Bat"}, {"Shovel"}, {"Pool Cue"}, {"Katana"}, {"Chainsaw"}, {"Purple Dildo"}, {"Small White Vibrator"},
  {"Large White Vibrator"}, {"Silver Vibrator"}, {"Flowers"}, {"Cane"}, {"Grenade"}, {"Tear Gas"}, {"Molotov Cocktail"}, {""}, {""}, {""}, {"Colt"}, {"Silenced 9mm"}, {"Desert Eagle"},
  {"Shotgun"}, {"Sawed off"}, {"Combat Shotgun"}, {"Micro SMG"}, {"MP5"}, {"AK-47"}, {"M4"}, {"Tec9"}, {"Rifle"}, {"Sniper Rifle"}, {"RPG"}, {"Homing RPG"},
  {"Flamethrower"}, {"Minigun"}, {"C4"}, {"Detonator"}, {"Spraycan"}, {"Fire Extinguisher"}, {"Camera"}, {"Nightvision Goggles"}, {"Thermal Goggles"},
  {"Parachute"}, {"Fake Pistol"}, {""}, {"Vehicle Ram"}, {"Helicopter Blades"}, {"Explosion"}, {""}, {"Drowned"}, {"Collision"}
};
static const VehicleNames[212][] =
{
  {"Landstalker"}, {"Bravura"}, {"Buffalo"}, {"Linerunner"}, {"Perrenial"}, {"Sentinel"}, {"Dumper"},
  {"Firetruck"}, {"Trashmaster"}, {"Stretch"}, {"Manana"}, {"Infernus"}, {"Voodoo"}, {"Pony"}, {"Mule"},
  {"Cheetah"}, {"Ambulance"}, {"Leviathan"}, {"Moonbeam"}, {"Esperanto"}, {"Taxi"}, {"Washington"},
  {"Bobcat"}, {"Mr Whoopee"}, {"BF Injection"}, {"Hunter"}, {"Premier"}, {"Enforcer"}, {"Securicar"},
  {"Banshee"}, {"Predator"}, {"Bus"}, {"Rhino"}, {"Barracks"}, {"Hotknife"}, {"Trailer 1"}, {"Previon"},
  {"Coach"}, {"Cabbie"}, {"Stallion"}, {"Rumpo"}, {"RC Bandit"}, {"Romero"}, {"Packer"}, {"Monster"},
  {"Admiral"}, {"Squalo"}, {"Seasparrow"}, {"Pizzaboy"}, {"Tram"}, {"Trailer 2"}, {"Turismo"},
  {"Speeder"}, {"Reefer"}, {"Tropic"}, {"Flatbed"}, {"Yankee"}, {"Caddy"}, {"Solair"}, {"Berkley's RC Van"},
  {"Skimmer"}, {"PCJ-600"}, {"Faggio"}, {"Freeway"}, {"RC Baron"}, {"RC Raider"}, {"Glendale"}, {"Oceanic"},
  {"Sanchez"}, {"Sparrow"}, {"Patriot"}, {"Quad"}, {"Coastguard"}, {"Dinghy"}, {"Hermes"}, {"Sabre"},
  {"Rustler"}, {"ZR-350"}, {"Walton"}, {"Regina"}, {"Comet"}, {"BMX"}, {"Burrito"}, {"Camper"}, {"Marquis"},
  {"Baggage"}, {"Dozer"}, {"Maverick"}, {"News Chopper"}, {"Rancher"}, {"FBI Rancher"}, {"Virgo"}, {"Greenwood"},
  {"Jetmax"}, {"Hotring"}, {"Sandking"}, {"Blista Compact"}, {"Police Maverick"}, {"Boxville"}, {"Benson"},
  {"Mesa"}, {"RC Goblin"}, {"Hotring Racer A"}, {"Hotring Racer B"}, {"Bloodring Banger"}, {"Rancher"},
  {"Super GT"}, {"Elegant"}, {"Journey"}, {"Bike"}, {"Mountain Bike"}, {"Beagle"}, {"Cropdust"}, {"Stunt"},
  {"Tanker"}, {"Roadtrain"}, {"Nebula"}, {"Majestic"}, {"Buccaneer"}, {"Shamal"}, {"Hydra"}, {"FCR-900"},
  {"NRG-500"}, {"HPV1000"}, {"Cement Truck"}, {"Tow Truck"}, {"Fortune"}, {"Cadrona"}, {"FBI Truck"},
  {"Willard"}, {"Forklift"}, {"Tractor"}, {"Combine"}, {"Feltzer"}, {"Remington"}, {"Slamvan"},
  {"Blade"}, {"Freight"}, {"Streak"}, {"Vortex"}, {"Vincent"}, {"Bullet"}, {"Clover"}, {"Sadler"},
  {"Firetruck LA"}, {"Hustler"}, {"Intruder"}, {"Primo"}, {"Cargobob"}, {"Tampa"}, {"Sunrise"}, {"Merit"},
  {"Utility"}, {"Nevada"}, {"Yosemite"}, {"Windsor"}, {"Monster A"}, {"Monster B"}, {"Uranus"}, {"Jester"},
  {"Sultan"}, {"Stratum"}, {"Elegy"}, {"Raindance"}, {"RC Tiger"}, {"Flash"}, {"Tahoma"}, {"Savanna"},
  {"Bandito"}, {"Freight Flat"}, {"Streak Carriage"}, {"Kart"}, {"Mower"}, {"Duneride"}, {"Sweeper"},
  {"Broadway"}, {"Tornado"}, {"AT-400"}, {"DFT-30"}, {"Huntley"}, {"Stafford"}, {"BF-400"}, {"Newsvan"},
  {"Tug"}, {"Trailer 3"}, {"Emperor"}, {"Wayfarer"}, {"Euros"}, {"Hotdog"}, {"Club"}, {"Freight Carriage"},
  {"Trailer 3"}, {"Andromada"}, {"Dodo"}, {"RC Cam"}, {"Launch"}, {"Police Car (LSPD)"}, {"Police Car (SFPD)"},
  {"Police Car (LVPD)"}, {"Police Ranger"}, {"Picador"}, {"S.W.A.T. Van"}, {"Alpha"}, {"Phoenix"}, {"Glendale"},
  {"Sadler"}, {"Luggage Trailer A"}, {"Luggage Trailer B"}, {"Stair Trailer"}, {"Boxville"}, {"Farm Plow"}, {"Utility Trailer"}
};
GetVehicleModelFromName(veh[])
{
  for(new i; i < sizeof VehicleNames; i++)
  {
    if(!strcmp(veh, VehicleNames[i], true)) return i + 400;
  }
  return -1;
}
SpawnPlayerVehicle(playerid, model)
{
  new Float: x, Float: y, Float: z, Float: ang;
  GetPlayerPos(playerid, x, y, z);
  GetPlayerFacingAngle(playerid, ang);
  if(OyuncuBilgileri[playerid][arac] != -1) DestroyPlayerVehicle(OyuncuBilgileri[playerid][arac]);
  new vehicleid = CreateVehicle(model, x, y, z, ang, -1, -1, -1);
  PutPlayerInVehicle(playerid, vehicleid, 0);
  SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
  OyuncuBilgileri[playerid][arac] = vehicleid;
  return 1;
}
DestroyPlayerVehicle(vehicleid)
{
  new Float: x, Float: y, Float: z;
  foreach(new i : Player)
  {
    if(OyuncuBilgileri[i][arac] == vehicleid) OyuncuBilgileri[i][arac] = -1;
    if(IsPlayerInVehicle(i, vehicleid))
    {
      //RemovePlayerFromVehicle(i);
      GetPlayerPos(i, x, y, z);
      SetPlayerPos(i, x, y, z + 1);
    }
  }

  DestroyVehicle(vehicleid);
}
IsInvalidNosVehicle(vehicleid)
{
  new InvalidNosVehicles[] =
  {
    581, 523, 462, 521, 463, 522, 461, 448, 468, 586,
    509, 481, 510, 472, 473, 493, 595, 484, 430, 453,
    452, 446, 454, 590, 569, 537, 538, 570, 449, 463,
    471
  };

  new VehModel = GetVehicleModel(vehicleid);

  for(new i; i < sizeof InvalidNosVehicles; i++) if(VehModel == InvalidNosVehicles[i]) return true;
  return false;
}

/*CMD:nos(playerid)
{
  if(OyuncuBilgileri[playerid][FREEROAM] == false)
   return hatamesaj(playerid,"Freeroamda bulunmalýsýnýz.");
  if(!IsPlayerInAnyVehicle(playerid)) return hatamesaj(playerid, "Araçta bulunmalýsýnýz."), 0;
  new veh = GetPlayerVehicleID(playerid);
  if(IsInvalidNosVehicle(veh)) return hatamesaj(playerid, "Bu araca nitro ekleyemezsiniz."), 0;

  AddVehicleComponent(veh, 1010);
  bilgimesaj(playerid, "Baþarýyla nitro araca eklendi. (10x)");
  return 1;
}
CMD:vehcolor(playerid, params[])
{
  if(OyuncuBilgileri[playerid][FREEROAM] == false)
   return hatamesaj(playerid,"Freeroamda bulunmalýsýnýz.");
  new color1, color2;
  if(sscanf(params, "ii", color1, color2)) return kullanmesaj(playerid, "/color [ID] [ID]"), 0;
  if(!IsPlayerInAnyVehicle(playerid)) return hatamesaj(playerid, "Araç içerisinde bulunmalýsýnýz. "), 0;
  if(0 < color1 > 254 || 0 < color2 > 254) return hatamesaj(playerid, "Araç rengi 0 ~ 254 aralýðýnda olmalýdýr. "), 0;

  ChangeVehicleColor(GetPlayerVehicleID(playerid), color1, color2);
  bilgimesaj(playerid, "Baþarýyla aracýn rengi deðiþtirildi!");
  return 1;
}
CMD:veh(playerid, params[])
{
  if(OyuncuBilgileri[playerid][FREEROAM] == false)
   return hatamesaj(playerid,"Freeroamda bulunmalýsýnýz.");
  new car[20], id = -1;
  if(sscanf(params, "s[20]", car)) return kullanmesaj(playerid, "/car [araç tam adý]"), 0;
  id = GetVehicleModelFromName(car);
  if(id == -1) return hatamesaj(playerid, "Hatalý araç adý!"), 0;
  SpawnPlayerVehicle(playerid, id);
  return 1;
}
*/
CMD:giveweapon(playerid, params[])
{
  static
      userid,
      weaponid,
      ammo;

    if(OyuncuBilgileri[playerid][adminlevel] < 3)
      return hatamesaj(playerid, "Yetkin yok!");

  if (sscanf(params, "udI(500)", userid, weaponid, ammo))
      return kullanmesaj(playerid, "/giveweapon [id] [silahid] [mermi]");

  if (!IsPlayerConnected(userid))
      return hatamesaj(playerid, "Belirttiðiniz oyuncu oyunda deðil.");

  if (weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
    return hatamesaj(playerid, "Geçersiz silah ID'sý.");
  GivePlayerWeapon(userid, weaponid, ammo);
  adminmesaj(1, 0xD01717FF,"[SISTEM] %s adlý admin %s adlý oyuncuya silah verdi.", OyuncuAdiGetir(playerid), OyuncuAdiGetir(userid));
  return 1;
}

CMD:jail(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 2)
    return 1;
  new hedefid, dakika, sebep[100];
    if(sscanf(params, "uds[100]", hedefid, dakika, sebep))
      return kullanmesaj(playerid, "/jail [hedef adý/ID] [dakika] [sebep]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);
  if(dakika <= 0)
    return hatamesaj(playerid, "Jail dakikasý 0'dan büyük olmalýdýr.");
  if(OyuncuBilgileri[hedefid][HapisDakika] >= 1)
    return hatamesaj(playerid, "Oyuncu zaten hapiste.");

  OyuncuBilgileri[hedefid][HapisDakika] = dakika;
  OyuncuBilgileri[hedefid][HapisTimer] = SetTimerEx("OyuncuHapis", TIMER_DAKIKA(1), true, "d", hedefid);
  JailGonder(hedefid);
  SetPlayerColor(hedefid, BEYAZ3);
  ResetPlayerWeapons(hedefid);
  YollaHerkeseMesaj(0xD01717FF, "[BILGI]"#BEYAZ2" %s, %s adlý oyuncuyu %s sebebiyle %d dakika cezalandýrdý.", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid), sebep, dakika);
  return 1;
}
CMD:unjail(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 2)
    return 1;
  new hedefid;
    if(sscanf(params, "u", hedefid))
      return kullanmesaj(playerid, "/unjail [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);
  if(OyuncuBilgileri[hedefid][HapisDakika] <= 0)
    return hatamesaj(playerid, "Bu kiþi hapiste deðil.");

  OyuncuBilgileri[hedefid][HapisDakika] = 0;
  KillTimer(OyuncuBilgileri[hedefid][HapisTimer]);
  LobiyeDon(hedefid);
  adminmesaj(1, 0xD01717FF, "[YONETIM]"#BEYAZ2" %s, %s adlý oyuncuyu hapisten çýkardý.", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid));
  return 1;
}
JailGonder(playerid)
{
  new sayi = random(4);
  switch(sayi)
  {
    case 0: SetPlayerPos(playerid, 215.3556, 110.7461, 999.0156);
    case 1: SetPlayerPos(playerid, 219.3807, 110.5989, 999.0156);
    case 2: SetPlayerPos(playerid, 223.5638, 110.5576, 999.0156);
    case 3: SetPlayerPos(playerid, 227.2564, 110.4045, 999.0156);
  }
  SetCameraBehindPlayer(playerid);
  SetPlayerInterior(playerid, 10);
  SetPlayerVirtualWorld(playerid, 0);

  new mesaj[900];
  strcat(mesaj, "- Oyunda seni diðer oyunculardan üstün kýlan mod kullanamazsýn.\n");
  strcat(mesaj, "- Chatte hakaret etmemelisin.\n");
  strins(mesaj, ""#BEYAZ2"", 0);
  ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_MSGBOX, "Magenta DM - Kurallar", mesaj, "Kapat", "");
}

function GirisKontrol(playerid)
{
  new rows, fields;
  cache_get_row_count(rows);
  cache_get_field_count(fields);
  new Float:S[4];
  if(rows)
  {
      cache_get_value_int(0, "sqlid", OyuncuBilgileri[playerid][sqlid]);
      cache_get_value_int(0, "adminlevel", OyuncuBilgileri[playerid][adminlevel]);
      cache_get_value_name(0, "isim", OyuncuBilgileri[playerid][isim],MAX_PLAYER_NAME+1);
      cache_get_value_int(0,"skor",OyuncuBilgileri[playerid][ skor ]);
      cache_get_value_int(0,"kiyafet",OyuncuBilgileri[playerid][ kiyafet ]);
      cache_get_value_int(0,"para",OyuncuBilgileri[playerid][ para ]);
        cache_get_value_int(0,"oldurme",OyuncuBilgileri[playerid][ oldurme]);
        cache_get_value_int(0,"Ilkbakis",OyuncuBilgileri[playerid][Ilkbakis]);
      cache_get_value_int(0, "susturdakika", OyuncuBilgileri[playerid][SusturDakika]);
      cache_get_value_int(0, "hapisdakika", OyuncuBilgileri[playerid][HapisDakika]);

        if(OyuncuBilgileri[playerid][Ilkbakis] == 1)
        {
          SetSpawnInfo(playerid, NO_TEAM, OyuncuBilgileri[playerid][kiyafet],S[0],S[1],S[2],S[3], 0, 0, 0, 0, 0, 0);
        SpawnPlayer( playerid );
        SetPlayerSkin(playerid,OyuncuBilgileri[playerid][kiyafet]);
        EkranTemizle( playerid );
        YollaHerkeseMesaj(0x008000FF, "[BILGI]"#BEYAZ2" %s sunucuya giriþ yaptý.", OyuncuAdiGetir(playerid));
        if(OyuncuBilgileri[playerid][SusturDakika] >= 1)
            OyuncuBilgileri[playerid][SusturTimer] = SetTimerEx("OyuncuSustur", TIMER_DAKIKA(1), true, "d", playerid);
        if(OyuncuBilgileri[playerid][HapisDakika] >= 1)
          {
            OyuncuBilgileri[playerid][HapisTimer] = SetTimerEx("OyuncuHapis", TIMER_DAKIKA(1), true, "d", playerid);
            JailGonder(playerid);
          }
      }
      else
      {
          LobiyeDon(playerid);
          SpawnPlayer( playerid );
      OyuncuBilgileri[playerid][Ilkbakis] = 1;
      EkranTemizle( playerid );
          YollaHerkeseMesaj(0x008000FF, "[BILGI]"#BEYAZ2" %s sunucuya kayýt oldu.", OyuncuAdiGetir(playerid));
      }

        ResetPlayerMoney( playerid );
        GivePlayerMoney(playerid, OyuncuBilgileri [ playerid ] [ para ] );
        SetPlayerScore(playerid, OyuncuBilgileri [ playerid ] [ skor ] );
        OyuncuBilgileri[playerid][GirisYapti] = 1;
  }
  else
  {
      HATALI_PASS[playerid]++;
    new string [256];
    if(HATALI_PASS[playerid] >= 3) return Kick(playerid);
    format(string,sizeof(string),"Merhaba %s lütfen giriþ yapmak için þifrenizi giriniz. [%d/3]",OyuncuAdiGetir(playerid),HATALI_PASS[playerid]);
    ShowPlayerDialog(playerid, DIALOG_GIRIS, DIALOG_STYLE_PASSWORD, "Magenta Deatmatch Hatalý þifre",string,"Giriþ Yap", "Çýkýþ");
  }
  return true;
}
FDMRANDKONUM(sayi)
{
//hopyavrum
  new fdmkonum[100];
  switch(sayi)
  {
    case 0: fdmkonum = "1225.46,300.11,19.55";
    case 1: fdmkonum = "1423.48,345.16,18.84";
    case 2: fdmkonum = "1311.42,401.12 ,9.55";
    case 3: fdmkonum = "1293.19,238.43,19.55";
    case 4: fdmkonum = "1290.75,176.89,20.46";
    case 5: fdmkonum = "1555.53, 31.78, 24.16";
    case 6: fdmkonum = "768.18, 305.07, 20.86";
    case 7: fdmkonum = "1192.59, 151.29, 20.51";
    case 8: fdmkonum = "1367.79, 477.19, 28.13";
	case 9: fdmkonum = "1217.51, 213.11, 19.55";
    //case 10: fdmkonum = "1192.59, 151.29, 28.51";

  }
  return fdmkonum;
}

LobiKonum(sayi)
{
  new konum[100];
  switch(sayi)
  {
    case 0: konum = "1701.4329,-1667.5564,20.2188";
    case 1: konum = "1710.9696,-1660.7762,20.2217";
    case 2: konum = "1709.8879,-1642.6309,20.2188";
    case 3: konum = "1712.4994,-1639.8804,20.2239";
    case 4: konum = "1726.7622,-1639.3290,20.2237";
    case 5: konum = "1723.6167,-1652.3280,20.0625"; // lobi burada
    case 6: konum = "1724.4646,-1655.5393,20.0625";
    case 7: konum = "1724.4646,-1655.5393,20.0625";
    case 8: konum = "1721.9342,-1660.2924,20.2306";
    case 9: konum = "1732.8134,-1658.8076,23.7198";
    case 10: konum = "1734.0770,-1645.8431,23.7444";
    case 11: konum = "1724.7504,-1640.2012,23.7041";
    case 12: konum = "1713.6927,-1642.5415,23.6797";
    case 13: konum = "1709.9712,-1651.3217,23.6953";
    case 14: konum = "1709.6027,-1666.0820,23.7027";
    case 15: konum = "1710.0959,-1660.4554,23.6953";
    case 16: konum = "1714.0796,-1672.2339,23.6953";
    case 17: konum = "1720.2054,-1676.8711,23.6966";
    case 18: konum = "1715.0841,-1672.3524,27.2036";
    case 19: konum = "1720.3561,-1672.5244,27.2059";
    case 20: konum = "1727.7512,-1669.9075,27.1953";
    case 21: konum = "1733.7020,-1659.2471,27.2253";
  }
  return konum;
}
AdmKonum(sayi)
{
  new AdmKonum[100];
  switch(sayi)
  {
    case 0: AdmKonum = "1701.4329,-1667.5564,20.2188";
    case 1: AdmKonum = "1710.9696,-1660.7762,20.2217";
    case 2: AdmKonum = "1709.8879,-1642.6309,20.2188";
    case 3: AdmKonum = "1712.4994,-1639.8804,20.2239";
    case 4: AdmKonum = "1726.7622,-1639.3290,20.2237";
    case 5: AdmKonum = "1723.6167,-1652.3280,20.0625";
    case 6: AdmKonum = "1724.4646,-1655.5393,20.0625";
    case 7: AdmKonum = "1724.4646,-1655.5393,20.0625";
    case 8: AdmKonum = "1721.9342,-1660.2924,20.2306";
    case 9: AdmKonum = "1732.8134,-1658.8076,23.7198";
    case 10: AdmKonum = "1734.0770,-1645.8431,23.7444";
    case 11: AdmKonum = "1724.7504,-1640.2012,23.7041";
    case 12: AdmKonum = "1713.6927,-1642.5415,23.6797";
    case 13: AdmKonum = "1709.9712,-1651.3217,23.6953";
    case 14: AdmKonum = "1709.6027,-1666.0820,23.7027";
    case 15: AdmKonum = "1710.0959,-1660.4554,23.6953";
    case 16: AdmKonum = "1714.0796,-1672.2339,23.6953";
    case 17: AdmKonum = "1720.2054,-1676.8711,23.6966";
    case 18: AdmKonum = "1715.0841,-1672.3524,27.2036";
    case 19: AdmKonum = "1720.3561,-1672.5244,27.2059";
    case 20: AdmKonum = "1727.7512,-1669.9075,27.1953";
    case 21: AdmKonum = "1733.7020,-1659.2471,27.2253";
  }
  return AdmKonum;
}

DMLVPDKonum(sayi)
{
  new lvpdkonum[100];
  switch(sayi)
  {
    case 0: lvpdkonum = "212.7434, 142.3439, 1003.0234";
    case 1: lvpdkonum = "300.8310, 185.2354, 1007.1719";
    case 2: lvpdkonum = "267.7838, 185.6091, 1008.1719";
    case 3: lvpdkonum = "245.7049, 185.5751, 1008.1719";
    case 4: lvpdkonum = "237.9269, 141.2811, 1003.0234";
    case 5: lvpdkonum = "208.9285, 142.0022, 1003.0300";
    case 6: lvpdkonum = "194.6322, 158.1613, 1003.0234";
    case 7: lvpdkonum = "228.5259, 183.1147, 1003.0313";
  }
  return lvpdkonum;
}
DMLIBERTCITYKonum(sayi)
{
  new libertcitykonum[100];
  switch(sayi)
  {
    case 0: libertcitykonum = "-794.806396, 497.738037, 1376.195312";
    case 1: libertcitykonum = "-782.8005,489.5347,1376.1953";
    case 2: libertcitykonum = "-781.6611,500.9633,1371.7490";
    case 3: libertcitykonum = "-800.7314,508.8372,1361.7324";
    case 4: libertcitykonum = "-829.2521,516.8877,1357.4347";
    case 5: libertcitykonum = "-789.8378,510.0251,1367.3672";
    case 6: libertcitykonum = "-799.2531,492.0835,1367.2328";
    case 7: libertcitykonum = "-839.3027,517.8335,1357.2672";
  }
  return libertcitykonum;
}
DMRCBATTLEKonum(sayi)
{
  new rcbattlekonum[100];
  switch(sayi)
  {
    case 0: rcbattlekonum = "-975.975708, 1060.983032, 1345.671875";
    case 1: rcbattlekonum = "-971.88, 1022.18, 1345.06";
    case 2: rcbattlekonum = "-975.8741, 1074.6154, 1344.9851";
    case 3: rcbattlekonum = "-971.9078,1089.3574,1344.9960";
    case 4: rcbattlekonum = "-1130.9077,1057.6787,1346.4141";
    case 5: rcbattlekonum = "-1136.4988,1073.6180,1345.9791";
    case 6: rcbattlekonum = "-1136.2219,1030.4789,1345.7584";
    case 7: rcbattlekonum = "-1089.6235,1040.8899,1344.5732";
  }
  return rcbattlekonum;
}
DMWAREHOUSEKonum(sayi)
{
  new dmwarehosekonum[100];
  switch(sayi)
  {
    case 0: dmwarehosekonum = "1412.639892, -1.787510, 1000.924377";
    case 1: dmwarehosekonum = "1370.9792,6.3688,1008.1563";
    case 2: dmwarehosekonum = "1360.0856,-34.2362,1007.8828";
    case 3: dmwarehosekonum = "1374.4846,-45.5246,1008";
    case 4: dmwarehosekonum = "1399.0632,-34.0766,1008.7657";
    case 5: dmwarehosekonum = "1416.6997,-26.3855,1008.7491";
    case 6: dmwarehosekonum = "1406.3168,-12.1959,1000.9142";
    case 7: dmwarehosekonum = "1390.8646,-24.4168,1000.9196";
  }
  return dmwarehosekonum;
}
HeadshotArenaKonum(sayi)
{
  new HeadshotArenaKonum[100];
  switch(sayi)
  {
    case 0: HeadshotArenaKonum = "1305.9468,-12.3781,1001.0333";
    case 1: HeadshotArenaKonum = "1305.8119,-24.9780,1001.0332";
    case 2: HeadshotArenaKonum = "1305.8119,-24.9780,1001.0332";
    case 3: HeadshotArenaKonum = "1305.6605,-38.8965,1001.0331";
    case 4: HeadshotArenaKonum = "1306.7078,-65.7015,1002.4922";
    case 5: HeadshotArenaKonum = "1250.7457,-62.8961,1002.4985";
    case 6: HeadshotArenaKonum = "1258.6726,3.3783,1001.0268";
    case 7: HeadshotArenaKonum = "1271.6343,-19.0418,1001.0258";
  }
  return HeadshotArenaKonum;
}
forward BugKontrol(playerid);
public BugKontrol(playerid)
{
  SetPlayerSkin(playerid, OyuncuBilgileri[playerid][kiyafet]);
  TogglePlayerControllable(playerid, 1);
  return 1;
}
forward LobiyeDon(playerid);
public LobiyeDon(playerid)
{

  SetPlayerColor(playerid, BEYAZ3);
  new sayi = random(22);
  sscanf(LobiKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
  SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
  SetPlayerFacingAngle(playerid, OyuncuBilgileri[playerid][Pos][3]);
  SetCameraBehindPlayer(playerid);
  SetPlayerHealth(playerid,10000);
  SetPlayerArmour(playerid, 0.0);
  SetPlayerVirtualWorld(playerid, 0);
  SetPlayerInterior(playerid, 18);
  SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
  ClearAnimations(playerid);
  ResetPlayerWeapons(playerid);
  GivePlayerWeapon(playerid, 24, 500);
  OyuncuBilgileri[playerid][LVPDDM] = false;
  OyuncuBilgileri[playerid][RCDM] = false;
  OyuncuBilgileri[playerid][CITYDM] = false;
  OyuncuBilgileri[playerid][WAREHOUSEDM] = false;
  OyuncuBilgileri[playerid][HEADSHOTDM] = false;
  OyuncuBilgileri[playerid][BALLASTEAM] = false;
  OyuncuBilgileri[playerid][GROVETEAM] = false;
  OyuncuBilgileri[playerid][FREEROAM] = false;
  OyuncuBilgileri[playerid][LOBI] = true;
  OyuncuBilgileri[playerid][pGOD] = false;
  SetPVarInt(playerid, "GodMode", 1);
  SetTimerEx("BugKontrol", 500, false, "d", playerid);

}
forward AdmGit(playerid);
public AdmGit(playerid)
{
  SetPlayerColor(playerid, DONATOR_RENK);
  new sayi = random(22);
  sscanf(AdmKonum(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
  SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
  SetPlayerFacingAngle(playerid, OyuncuBilgileri[playerid][Pos][3]);
  SetCameraBehindPlayer(playerid);
  SetPlayerHealth(playerid,100);
  SetPlayerArmour(playerid, 0.0);
  SetPlayerVirtualWorld(playerid, 0);
  SetPlayerInterior(playerid, 18);
  SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
  ClearAnimations(playerid);
  ResetPlayerWeapons(playerid);
  GivePlayerWeapon(playerid, 24, 500);
  OyuncuBilgileri[playerid][LVPDDM] = false;
  OyuncuBilgileri[playerid][RCDM] = false;
  OyuncuBilgileri[playerid][CITYDM] = false;
  OyuncuBilgileri[playerid][WAREHOUSEDM] = false;
  OyuncuBilgileri[playerid][HEADSHOTDM] = false;
  OyuncuBilgileri[playerid][BALLASTEAM] = false;
  OyuncuBilgileri[playerid][GROVETEAM] = false;
  OyuncuBilgileri[playerid][FREEROAM] = false;
  OyuncuBilgileri[playerid][LOBI] = false;
  OyuncuBilgileri[playerid][ADM] = true;
  OyuncuBilgileri[playerid][pGOD] = false;
  SetPVarInt(playerid, "GodMode", 0);
  SetTimerEx("BugKontrol", 500, false, "d", playerid);
}

stock report_bosID()
{
  new id;
  for(new i = 0; i < MAX_PLAYERS; i++)
  {
      if(Reportlar[i][acildiMi1] == 0)
    {
        id = i;
        break;
    }
  }
  return id;
}

stock convertNumber(value)
{
    new string[24];
    format(string, sizeof(string), "%d", value);
    for(new i = (strlen(string) - 3); i > (value < 0 ? 1 : 0) ; i -= 3)
    {
        strins(string[i], ",", 0);
    }
    return string;
}
stock IPGetir(playerid)
{
   new plrIP[16];
   GetPlayerIp(playerid, plrIP, sizeof(plrIP));
   return plrIP;
}

stock TarihGetir()
{
  new tarih[64];
  new y,m,d,h,mi;
  getdate(y, m, d), gettime(h, mi);
  format(tarih,sizeof(tarih),"%02d.%02d.%d %02d:%02d",d, m, y, h, mi);
  return tarih;
}


public OnPlayerDeath(playerid, killerid, reason)
{
  if(OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true || OyuncuBilgileri[playerid][HEADSHOTDM] == true)
  {
    new weaponName[32];
    GetWeaponName(reason, weaponName, sizeof(weaponName));
    if(killerid == INVALID_PLAYER_ID)
    {
      bilgimesaj(playerid, "Çeþitli nedenlerden dolayý öldün.");
    }
    else
    {
       SetPlayerHealth(killerid, 100);
       foreach(new i : Player)
        {
          if(OyuncuBilgileri[i][LVPDDM] == true)
           {
            bilgimesaj(i, "ARENA: %s adlý oyuncu %s kiþisini %s ile öldürdü.", OyuncuAdiGetir(killerid), OyuncuAdiGetir(playerid), weaponName);
           }
        }
    }
  if(OyuncuBilgileri[playerid][BALLASTEAM] == true && OyuncuBilgileri[playerid][GROVETEAM] == true)
  {
      bilgimesaj(killerid, "%s kiþisini öldürdünüz.", OyuncuAdiGetir(playerid));
      bilgimesaj(playerid, "%s tarafýndan %s ile öldürüldün.", OyuncuAdiGetir(killerid), weaponName);
  }
  }
  OyuncuBilgileri[killerid][oldurme]++;
  OyuncuBilgileri[playerid][olme]++;
  ParaVer(killerid, 100);
  ParaVer(playerid, -50);
  SkorVer(killerid, 1);
  SendDeathMessage(killerid, playerid, reason);
  return 1;
}

stock ParaBirimi(iNum, const szChar[] = ",")
{
    new szStr[16];
    format(szStr, sizeof(szStr), "%d", iNum);
  for(new iLen = strlen(szStr) - 3; iLen > 0; iLen -= 3)
  {
    strins(szStr, szChar, iLen);
    }
    return szStr;
}

function PlayerIDTemizle(playerid)
{
  HATALI_PASS[playerid] = 0;
  OyuncuBilgileri[playerid][sqlid] = 0;
  OyuncuBilgileri[playerid][adminlevel] = 0;
  yapistir(OyuncuBilgileri[playerid][isim],"NULL",MAX_PLAYER_NAME+1);
  OyuncuBilgileri[playerid][GirisYapti] = 0;
  OyuncuBilgileri[playerid][skor] = 0;
  OyuncuBilgileri[playerid][kiyafet] = 0;
  OyuncuBilgileri[playerid][para] = 0;
  OyuncuBilgileri[playerid][oldurme] = 0;
  OyuncuBilgileri[playerid][olme] = 0;
  OyuncuBilgileri[playerid][Ilkbakis] = 0;
  OyuncuBilgileri[playerid][LVPDDM] = false;
  OyuncuBilgileri[playerid][RCDM] = false;
  OyuncuBilgileri[playerid][CITYDM] = false;
  OyuncuBilgileri[playerid][WAREHOUSEDM] = false;
  OyuncuBilgileri[playerid][HEADSHOTDM] = false;
  OyuncuBilgileri[playerid][BALLASTEAM] = false;
  OyuncuBilgileri[playerid][ADM] = false;
  OyuncuBilgileri[playerid][FREEROAM] = false;
  OyuncuBilgileri[playerid][GROVETEAM] = false;
  OyuncuBilgileri[playerid][LOBI] = false;
  OyuncuBilgileri[playerid][pGOD] = false;
  return true;
}

function ParaVer(playerid,miktar)
{
  ResetPlayerMoney(playerid);
  OyuncuBilgileri[playerid][para] += miktar;
  GivePlayerMoney(playerid, OyuncuBilgileri[playerid][para]);
  new KucukString[256];
  if(miktar < 0)
  {
    PlayerPlaySound(playerid,1084,0,0,0);
    format(KucukString,sizeof(KucukString),"~r~%d$",miktar);
    GameTextForPlayer(playerid, KucukString, 3000, 1);
  }
  else
  {
    PlayerPlaySound(playerid,1083,0,0,0);
    format(KucukString,sizeof(KucukString),"~g~%d$",miktar);
    GameTextForPlayer(playerid, KucukString, 3000, 1);
  }
  return true;
}
SkorVer(playerid, miktar)
{
  new mesaj[30];
  GameTextForPlayer(playerid, mesaj, 3000, 1);
  OyuncuBilgileri[playerid][skor] += miktar;
  SetPlayerScore(playerid, OyuncuBilgileri[playerid][skor]);
  OyuncuGuncelle(playerid);
}



function OyuncuGuncelle(i)
{
   new guncelle[256*2];
   new Float:x,Float:y,Float:z,Float:a;
   GetPlayerPos(i,x,y,z);
   GetPlayerFacingAngle(i,a);
   format(guncelle, sizeof(guncelle), "UPDATE oyuncular SET `hapisdakika` = '%d', `susturdakika` = '%d',`adminlevel` = '%d', `skor` = '%d', `kiyafet` = '%d', `para` = '%d', `oldurme` = '%d', `olme` = '%d', `Ilkbakis` = '%d' WHERE `sqlid`='%d'",
   OyuncuBilgileri[i][HapisDakika],
   OyuncuBilgileri[i][SusturDakika],
   OyuncuBilgileri[i][adminlevel],
   OyuncuBilgileri[i][skor],
   OyuncuBilgileri[i][kiyafet],
   OyuncuBilgileri[i][para],
   OyuncuBilgileri[i][oldurme],
   OyuncuBilgileri[i][olme],
   OyuncuBilgileri[i][Ilkbakis],
   OyuncuBilgileri[i][sqlid]
   );
   mysql_query(alomitymerdsql,guncelle,false);
   return true;
}
YoneticiYetkiAdi(yetki)
{
  new yetkiadi[124];
  switch(yetki)
  {
    case 0: yetkiadi = ""#KIRMIZI2"Oyuncu"#BEYAZ2"";
    case 1: yetkiadi = ""#MAVI2"Moderatör"#BEYAZ2"";
    case 2: yetkiadi = ""#YESIL2"Game Admin"#BEYAZ2"";
    case 3: yetkiadi = ""#TURUNCU2"Lead Admin"#BEYAZ2"";
    case 4: yetkiadi = ""#KIRMIZI2"Management"#BEYAZ2"";
    case 5: yetkiadi = "";
    case 6: yetkiadi = "";
    case 7: yetkiadi = "";
  }
  return yetkiadi;
}
adminmesajdefine(yetki, renk, const mesaj[])
{
    if(mesaj[0] == '\0')
    return;
  foreach(new i : Player)
  {
        if(OyuncuBilgileri[i][adminlevel] >= yetki)
        {
      SendClientMessage(i, renk, mesaj);
        }
    }
}

SoruMesajDefine(renk, const mesaj[])
{
    if(mesaj[0] == '\0') return;
  foreach(new i : Player)
  {
      SendClientMessage(i, renk, mesaj);
    }
}


CMD:cw(playerid, params[])
{

new vehicleid = GetPlayerVehicleID(playerid);
if(!IsPlayerInAnyVehicle(playerid) && !IsABike(vehicleid)) return hatamesaj(playerid, "Araç dýþýnda bu komutu kullanamazsýn!");
if (isnull(params)) return kullanmesaj(playerid, "/cw [yazý]");
SendVehicleMessage(GetPlayerVehicleID(playerid), 0x05B3FFFF, "[Araç Içi] %s: %s", OyuncuAdiGetir(playerid), params);
return 1;
}
CMD:amute(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 1)
    return 1;
  new hedefid, dakika, sebep[100];
  if(sscanf(params, "udS(-1)[100]", hedefid, dakika, sebep))
    return kullanmesaj(playerid, "/sustur [hedef adý/ID] [dakika] [sebep]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);
  if(dakika >= 4)
    return hatamesaj(playerid, "Oyuncuyu sadece 1-3 dakika arasý susturabilirsin.");

  if(dakika == 0)
  {
    OyuncuBilgileri[hedefid][SusturDakika] = dakika;
    KillTimer(OyuncuBilgileri[hedefid][SusturTimer]);
    YollaHerkeseMesaj(0x008000FF, "[BILGI]"#BEYAZ2" %s, %s adlý oyuncuyu susturmasýný kaldýrdý.", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid));
    return 1;
  }
  if(strval(sebep) == -1)
    return kullanmesaj(playerid, "/sustur [hedef adý/ID] [dakika] [sebep]");
  OyuncuBilgileri[hedefid][SusturTimer] = SetTimerEx("OyuncuSustur", TIMER_DAKIKA(1), true, "d", hedefid);
  OyuncuBilgileri[hedefid][SusturDakika] = dakika;
  YollaHerkeseMesaj(0x008000FF, "[BILGI]"#BEYAZ2" %s, %s adlý oyuncuyu %s sebebiyle %d dakika susturdu.", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid), sebep, dakika);
  return 1;
}
CMD:aspec(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 1)
  return 1;

  new hedefid;
  if(sscanf(params, "u", hedefid))
    return kullanmesaj(playerid, "/aspec [hedef adý/ID]");
  if(playerid == hedefid)
    return hatamesaj(playerid, "Kendini izleyemezsin.");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);
    new ip[16];
  GetPlayerIp(hedefid , ip, sizeof(ip));

  OyuncuBilgileri[playerid][VW] = GetPlayerVirtualWorld(playerid);
  OyuncuBilgileri[playerid][Int] = GetPlayerInterior(playerid);
  SetPlayerInterior(playerid, GetPlayerInterior(hedefid));
  SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(hedefid));
  TogglePlayerSpectating(playerid, 1);
  if(IsPlayerInAnyVehicle(hedefid))
    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(hedefid));
  else PlayerSpectatePlayer(playerid, hedefid);

  bilgimesaj(playerid, "%s adlý oyuncuyu izliyorsun; PING: [%d] FPS: [%d] IP: [%s]", OyuncuAdiGetir(hedefid), GetPlayerPing(hedefid), GetPlayerFPS(hedefid), ip);
  return 1;
}

CMD:aspecoff(playerid, params[])
{
    if(OyuncuBilgileri[playerid][adminlevel] < 1)
    return 1;
  if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    return hatamesaj(playerid, "Kimseyi izlemiyorsun.");

  TogglePlayerSpectating(playerid, 0);
  LobiyeDon(playerid);
  bilgimesaj(playerid, "Izlemeden çýktýn.");
  return 1;
}
CMD:yardim(playerid, params[])
{

  ShowPlayerDialog(playerid, DIALOG_YARDIM, DIALOG_STYLE_LIST, "Yardým Menü", "{EEDD82}»{FFFFFF} TDM Komutlarý\n{EEDD82}»{FFFFFF} DM Komutlarý\n{EEDD82}»{FFFFFF} Freeroam Komutlarý\n{EEDD82}»{FFFFFF} Genel Komutlar", "Seç", "Çýk");
  return 1;
}

CMD:respawncar(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 2) return 0;
    new vehicleid;
    if(sscanf( params, "i", vehicleid )) return kullanmesaj(playerid, "/aspawn <aracid>" );
    DestroyVehicle(vehicleid);
    bilgimesaj(playerid, "%d ID'li aracý spawnladýn.", vehicleid);
    return 1;
}
CMD:a(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 1)
    return 1;
  new mesaj[150];
  if(sscanf(params, "s[150]", mesaj))
    return kullanmesaj(playerid, "/a [mesaj]");
  adminmesaj(1, YONETIM_RENK, "[YONETIM] %s %s - (%d):"#BEYAZ2" %s", YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]), OyuncuAdiGetir(playerid), playerid, mesaj);
  return 1;
}
CMD:restart(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 3)
    return 1;
  YollaHerkeseMesaj(KIRMIZI, "%s adlý admin tarafýndan sunucu yeniden baþlatýlýyor.", OyuncuAdiGetir(playerid));
  SendRconCommand("gmx");

  return 1;
}

CMD:setskin(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 2)
    return 1;
  new hedefid, skiyafet;
  if(sscanf(params, "ud", hedefid, skiyafet))
    return kullanmesaj(playerid, "/setskin [hedef adý/ID] [skin ID]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);
  OyuncuBilgileri[hedefid][kiyafet] = skiyafet;
  SetPlayerSkin(hedefid, OyuncuBilgileri[hedefid][kiyafet]);
  bilgimesaj(hedefid, "%s adlý yönetici kýyafetini %d yaptý.", OyuncuAdiGetir(playerid), skiyafet);
  bilgimesaj(playerid, "%s adlý oyuncunun kýyafetini %d yaptýn.", OyuncuAdiGetir(hedefid), skiyafet);
  return 1;
}

CMD:pm(playerid, params[])
{

  new hedefid, mesaj[150];
  if(sscanf(params, "us[150]", hedefid, mesaj))
    return kullanmesaj(playerid, "/pm [hedef adý/ID] [mesaj]");
  if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);
  if(playerid == hedefid)
    return hatamesaj(playerid, "Kendine PM atamazsýn.");
  if(OyuncuBilgileri[hedefid][PMizin] == true)
    return hatamesaj(playerid, "Kiþi özel mesajýný kapatmýþ.");
  if(OyuncuBilgileri[playerid][PMizin] == true)
      return hatamesaj(playerid, "Özel mesajýn kapalý.");

  YollaFormatMesaj(playerid, 0xB79400FF, "[PM] %s(%d) kiþisine: %s", OyuncuAdiGetir(hedefid), hedefid, mesaj);
  YollaFormatMesaj(hedefid, 0xE5B900FF, "[PM] %s(%d) kiþisinden: %s", OyuncuAdiGetir(playerid), playerid, mesaj);
  return 1;
}
OyundaDegilMesaj(playerid)
{
  return hatamesaj(playerid, "Hedef oyunda deðil veya Hatalý ID.");
}
CMD:pmkapat(playerid, params[])
{

  if(OyuncuBilgileri[playerid][PMizin] == true)
  {
    OyuncuBilgileri[playerid][PMizin] = false;
    bilgimesaj(playerid, "Özel mesajlarýný açtýn artýk özel mesaj alabilirsin.");
    return 1;
  }
  if(OyuncuBilgileri[playerid][PMizin] == false)
  {
    OyuncuBilgileri[playerid][PMizin] = true;
    bilgimesaj(playerid, "Özel mesajlarýný kapattýn artýk Özel mesaj almayacaksýn.");
    return 1;
  }
  return 1;

}
CMD:goto(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 1)
    return hatamesaj(playerid, "Yeterli yetkiye sahip deðilsin.");
  new hedefid, Float: hedefPos[3];
    if(sscanf(params, "u", hedefid))
      return kullanmesaj(playerid, "/goto [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  GetPlayerPos(hedefid, hedefPos[0], hedefPos[1], hedefPos[2]);
  SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(hedefid));
  SetPlayerInterior(playerid, GetPlayerInterior(hedefid));
  SetPlayerPos(playerid, hedefPos[0], hedefPos[1]+2, hedefPos[2]);

  bilgimesaj(playerid, "%s adlý oyuncunun yanýna ýþýnlandýn.", OyuncuAdiGetir(hedefid));
  return 1;
}

CMD:agoto(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 1)
    return 1;
  new hedefid, Float: hedefPos[3];
    if(sscanf(params, "u", hedefid))
      return kullanmesaj(playerid, "/goto [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  GetPlayerPos(hedefid, hedefPos[0], hedefPos[1], hedefPos[2]);
  SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(hedefid));
  SetPlayerInterior(playerid, GetPlayerInterior(hedefid));
  SetPlayerPos(playerid, hedefPos[0], hedefPos[1]+2, hedefPos[2]);
  bilgimesaj(hedefid, "%s adlý yönetici yanýna ýþýnlandý.", OyuncuAdiGetir(playerid));
  bilgimesaj(playerid, "%s adlý oyuncunun yanýna ýþýnlandýn.", OyuncuAdiGetir(hedefid));
  return 1;
}

CMD:gethere(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 1)
    return 1;

  new hedefid, Float: hedefPos[3];
  if(sscanf(params, "u", hedefid))
    return kullanmesaj(playerid, "/gethere [hedef adý/ID]");
  if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  GetPlayerPos(playerid, hedefPos[0], hedefPos[1], hedefPos[2]);
  SetPlayerInterior(hedefid, GetPlayerInterior(playerid));
  SetPlayerVirtualWorld(hedefid, GetPlayerVirtualWorld(playerid));
  SetPlayerPos(hedefid, hedefPos[0], hedefPos[1]+2, hedefPos[2]);
  bilgimesaj(hedefid, "%s adlý yönetici seni yanýna çekti.", OyuncuAdiGetir(playerid));
  bilgimesaj(playerid, "%s adlý oyuncuyu yanýna çektin.", OyuncuAdiGetir(hedefid));
  return 1;
}
CMD:sethpall(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 2)
    return 1;

  new miktar;
    if(sscanf(params, "i", miktar))
      return kullanmesaj(playerid, "/sethpall [miktar]");
  if(OyuncuBilgileri[playerid][GirisYapti] == true)
  {
      foreach(new i : Player)
    SetPlayerHealth(i, miktar);
    YollaHerkeseMesaj(0x008000FF, "[BILGI]"#BEYAZ2" %s adlý admin herkesin canýný %d olarak ayarladý.", OyuncuAdiGetir(playerid), miktar);
  }
  return 1;
}
CMD:sethp(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 3)
    return 1;

  new hedefid, miktar;
    if(sscanf(params, "ui", hedefid, miktar))
      return kullanmesaj(playerid, "/sethp [hedef adý/ID] [miktar]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  SetPlayerHealth(hedefid, miktar);
  bilgimesaj(hedefid, "%s adlý yönetici canýný %d yaptý.", OyuncuAdiGetir(playerid), miktar);
  bilgimesaj(playerid, "%s adlý oyuncunun canýný %d yaptýn.", OyuncuAdiGetir(hedefid), miktar);
  return 1;
}

CMD:spawngonder(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] >= 1)
  {
  new hedefid;
    if(sscanf(params, "u", hedefid))
      return kullanmesaj(playerid, "/spawn [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  LobiyeDon(hedefid);
  SetPlayerVirtualWorld(hedefid, 0);
  SetPlayerInterior(hedefid, 10);
  SetCameraBehindPlayer(hedefid);
  bilgimesaj(hedefid, "%s adlý yönetici tarafýndan lobiye spawn oldun.", OyuncuAdiGetir(playerid));
  bilgimesaj(playerid, "%s adlý oyuncuyu lobiye spawnladýn.", OyuncuAdiGetir(hedefid));
  }
  return 1;
}
CMD:m4(playerid, params[])
{
if (OyuncuBilgileri[playerid][LOBI])
        return SendClientMessage(playerid, -1, "{ff0000}[!]{ffffff} Lobide bu komutu kullanamazsýnýz.");
  if(GetPlayerMoney(playerid) < 2500) return hatamesaj(playerid, "Yeterli paranýz yok.");
  if(!spamProtect(playerid, "m4flood", 60))
        return SendClientMessage(playerid, -1, "{ff0000}[!]{ffffff} Tekrar kullanmak için 60 saniye bekleyin!");
      ParaVer(playerid, -2500);
      GivePlayerWeapon(playerid, 31, 200);

      bilgimesaj(playerid, "M4 satýn alýndý.");
      return 1;
}


CMD:discorddogrula(playerid)
{
             if(!spamProtect(playerid, "odul1flood", 60))
	return SendClientMessage(playerid, -1, "{ff0000}[!]{ffffff} Doðrulama kodunu 60 saniyede bir kez alabilirsiniz.");
   new str[70], randMSG = random(sizeof(RandomMSGG));
   format(str,sizeof(str),"%s", RandomMSGG[randMSG]);
   DCC_SendChannelMessage(g_Discord_Chat, str);
   bilgimesaj(playerid, "Doðrulama kodunuza discord-dogrulama kanalýndan ulaþabilirsiniz. Doðrulamaya /dogrula komutuyla devam edebilirsiniz.");
   discordDog[playerid][discordKodu] = str;
   str = discordDog[playerid][discordKodu];
   return 1;
}

CMD:dogrula(playerid, params[])
{
   new girilen[70];
 if(sscanf(params, "s[70]", girilen)) return SendClientMessage(playerid, -1, "Kullan:/dogrula [Kod]");
   if(girilen[0] != discordDog[playerid][discordKodu])
   return
   hatamesaj(playerid, "Kodu yanlýþ girdiniz. Tekrar deneyin.");
             if(!spamProtect(playerid, "odul1flood", 86400))
	return SendClientMessage(playerid, -1, "{ff0000}[!]{ffffff} Günlük ödülü 24 saatte bir alabilirsiniz.");
 if(girilen[0] == discordDog[playerid][discordKodu])
   {
      SkorVer(playerid, 10);
      ParaVer(playerid, 10000);
      bilgimesaj(playerid, "Discord hesabýnýz doðrulandý. Ödül olarak 10.000$ ve 20 skor kazandýnýz. 24 saat sonra tekrar ödülünüzü alabilirsiniz.");
   }
   return 1;
}
CMD:zirh(playerid, params[])
{
if (OyuncuBilgileri[playerid][LOBI])
        return SendClientMessage(playerid, -1, "{ff0000}[!]{ffffff} Lobide bu komutu kullanamazsýnýz.");


  if(GetPlayerMoney(playerid) < 1000) return hatamesaj(playerid, "Yeterli paranýz yok.");
  if(!spamProtect(playerid, "armorflood", 60))
		return SendClientMessage(playerid, -1, "{ff0000}[!]{ffffff} Tekrar kullanmak için 60 saniye bekleyin!");
      ParaVer(playerid, -1000);
      SetPlayerArmour(playerid, 100);

      bilgimesaj(playerid, "Zýrh satýn alýndý.");
      return 1;
}
bosYasakID()
{
  new temp[123], Cache: result, lastid, id, returnable = 1, maxid = 1, j;
  result = mysql_query(alomitymerdsql, "SELECT yasakID FROM yasaklar ORDER BY yasakID ASC");
  j = cache_num_rows();
  for(new i = 0; i < j; i++)
  {
    maxid++;
    cache_get_value_name(i, "yasakID", temp), id = strval(temp);
      if(id - lastid > 1)
      {
        returnable = lastid+1;
        cache_delete(result);
        return returnable;
      }
      lastid = id;
  }
  cache_delete(result);
  return maxid;
}
strreplace(string[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = sizeof(string))
{// No need to do anything if the limit is 0.
    if(limit == 0) return 0;
    new sublen = strlen(search), replen = strlen(replacement), bool:packed = ispacked(string), maxlen = maxlength, len = strlen(string), count = 0;
    // "maxlen" holds the max string length (not to be confused with "maxlength", which holds the max. array size).
    // Since packed strings hold 4 characters per array slot, we multiply "maxlen" by 4.
    if (packed)
        maxlen *= 4;// If the length of the substring is 0, we have nothing to look for..
    if (!sublen)
        return 0;// In this line we both assign the return value from "strfind" to "pos" then check if it's -1.
    while (-1 != (pos = strfind(string, search, ignorecase, pos)))
  {// Delete the string we found
        strdel(string, pos, pos + sublen);
        len -= sublen;// If there's anything to put as replacement, insert it. Make sure there's enough room first.
        if (replen && len + replen < maxlen) {
            strins(string, replacement, pos, maxlength);

            pos += replen;
            len += replen;
        }// Is there a limit of number of replacements, if so, did we break it?
        if (limit != -1 && ++count >= limit)
            break;
    }
    return count;
}
TRcevir(trstring[])
{
    new trstr[100];
    format(trstr, 100, "%s", trstring);
  strreplace(trstr, "ð","g");
  strreplace(trstr, "Ð","G");
  strreplace(trstr, "þ","s");
  strreplace(trstr, "Þ","S");
  strreplace(trstr, "ý","i");
  strreplace(trstr, "I","I");
  strreplace(trstr, "I","I");
  strreplace(trstr, "ö","o");
  strreplace(trstr, "Ö","O");
  strreplace(trstr, "ç", "c");
  strreplace(trstr, "Ç","C");
  strreplace(trstr, "ü", "u");
  strreplace(trstr, "Ü","U");
  return trstr;
}
Tarih(timestamp, _form = 3) // date - Tarihi çek
{
    /*~ convert a Timestamp to a Date. ~ 10.07.2009
    date( 1247182451 )  will print >> 09.07.2009-23:34:11 ____ date( 1247182451, 1) will print >> 09/07/2009, 23:34:11
    date( 1247182451, 2) will print >> July 09, 2009, 23:34:11 ____ date( 1247182451, 3) will print >> 9 Jul 2009, 23:34
    */
    new year = 1970, day = 0, month = 0, hour = 3, mins = 0, sec = 0, returnstring[32];
    new days_of_month[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
    new names_of_month[12][10] = {"Ocak","Þubat","Mart","Nisan","Mayýs","Haziran","Temmuz","Aðustos","Eylül","Ekim","Kasým","Aralýk"};
    while(timestamp>31622400)
  {
        timestamp -= 31536000;
        if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) timestamp -= 86400;
        year++;
    }
    if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0))
        days_of_month[1] = 29;
    else
        days_of_month[1] = 28;
    while(timestamp>86400)
  {
        timestamp -= 86400, day++;
        if(day==days_of_month[month]) day=0, month++;
    }
    while(timestamp>60)
  {
        timestamp -= 60, mins++;
        if( mins == 60) mins=0, hour++;
    }
    sec=timestamp;
    switch(_form)
  {
        case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d:%02d", day+1, month+1, year, hour, mins, sec);
        case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hour, mins, sec);
        case 3: format(returnstring, 31, "%d %s %d - %02d:%02d", day+1,names_of_month[month],year,hour,mins);
        default: format(returnstring, 31, "%02d.%02d.%d-%02d:%02d:%02d", day+1, month+1, year, hour, mins, sec);
    }
    return returnstring;
}
ReturnUser(const text[])
{
  new strPos, returnID = 0, bool: isnum = true;
  while(text[strPos])
  {
    if(isnum)
    {
      if('0' <= text[strPos] <= '9') returnID = (returnID * 10) + (text[strPos] - '0');
      else isnum = false;
    }
    strPos++;
  }
  if(isnum)
  {
    if(IsPlayerConnected(returnID)) return returnID;
  }
  else
  {
    new sz_playerName[MAX_PLAYER_NAME];

    foreach(new i : Player)
    {
      GetPlayerName(i, sz_playerName, MAX_PLAYER_NAME);
      if(!strcmp(sz_playerName, text, true, strPos)) return i;
    }
  }
  return INVALID_PLAYER_ID;
}

CMD:slap(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 2)
    return 1;

  new hedefid, Float: hedefPos[3];
    if(sscanf(params, "u", hedefid))
      return kullanmesaj(playerid, "/slap [hedef adý/ID]");
  if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  GetPlayerPos(hedefid, hedefPos[0], hedefPos[1], hedefPos[2]);
  SetPlayerPos(hedefid, hedefPos[0], hedefPos[1], hedefPos[2]+5);
  bilgimesaj(hedefid, "%s adlý yönetici seni tokatladý.", OyuncuAdiGetir(playerid));
  bilgimesaj(playerid, "%s adlý oyuncuyu tokatladýn.", OyuncuAdiGetir(hedefid));
  return 1;
}
cmd:freeroam(playerid, params[])
{
  if(OyuncuBilgileri[playerid][HapisDakika] >= 1)
  hatamesaj(playerid, "Hapiste olduðun için komut kullanamazsýn, hapisin bitmesine %d kaldý.", OyuncuBilgileri[playerid][HapisDakika]);
  if(OyuncuBilgileri[playerid][BALLASTEAM] == true || OyuncuBilgileri[playerid][GROVETEAM] == true || OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true || OyuncuBilgileri[playerid][HEADSHOTDM] == true)
  return hatamesaj(playerid, "Þuan lobilere katýlamazsýn! (zaten lobilerden birindesiniz)");
  OyuncuBilgileri[playerid][FREEROAM] = true;
  OyuncuBilgileri[playerid][LOBI] = false;
  SetPlayerPos(playerid, 1129.31, -1490.00, 22.77);
  SetPlayerInterior(playerid, 0);
  SetPlayerVirtualWorld(playerid, 31214);
  return 1;
}
CMD:health(playerid, params[])
{
  if(OyuncuBilgileri[playerid][FREEROAM] == false)
    return hatamesaj(playerid, "Freeroamda bulunmalýsýnýz.");

  new miktar;
    if(sscanf(params, "i", miktar))
      return kullanmesaj(playerid, "/health [miktar]");

  SetPlayerHealth(playerid, miktar);
  bilgimesaj(playerid, "Canýný %d yaptýn.", miktar);
  return 1;
}
CMD:armor(playerid, params[])
{
  if(OyuncuBilgileri[playerid][FREEROAM] == false)
    return hatamesaj(playerid, "Freeroamda bulunmalýsýnýz.");

  new miktar;
    if(sscanf(params, "i", miktar))
      return kullanmesaj(playerid, "/armor [miktar]");

  SetPlayerArmour(playerid, miktar);
  bilgimesaj(playerid, "Armorunu %d yaptýn.", miktar);
  return 1;
}
CMD:wep(playerid, params[])
{
    if(OyuncuBilgileri[playerid][FREEROAM] == true)
    {
    Dialog_Show(playerid, WeaponMenu, DIALOG_STYLE_LIST, "Silah Menu", "Colt 45\nSD Pistol\nDesert Eagle\nShotgun\nSawn-off Shotgun\nCombat Shotgun\nMAC-10\nMP5\nAK47\nM4\nTEC9\nRIFLE\nSniper Rifle\nRPG\nHeat Seaker\nCamera", "Seç", "Kapat");
    }
    else
    {
    hatamesaj(playerid, "Freeroamda bulunmalýsýnýz.");
    }
    return 1;
}

Dialog:WeaponMenu(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new str[64];
        format(str, 64, "'%s' adlý silahý aldýnýz.", inputtext);

        GivePlayerWeapon(playerid, listitem + 22, 500);
        bilgimesaj(playerid, str);
    }
    return 1;
}
CMD:freeze(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 1)
    return 1;
  new hedefid;
  if(sscanf(params, "u", hedefid))
      return kullanmesaj(playerid, "/freeze [hedef adý/ID]");
  if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  if(OyuncuBilgileri[hedefid][FreezeDurumu] == false)
  {
    TogglePlayerControllable(hedefid, 0);
    OyuncuBilgileri[hedefid][FreezeDurumu] = true;
    bilgimesaj(hedefid, "%s adlý yönetici seni freezeledi.", OyuncuAdiGetir(playerid));
    bilgimesaj(playerid, "%s adlý oyuncuyu freezeledin.", OyuncuAdiGetir(hedefid));
    return 1;
  }
  TogglePlayerControllable(hedefid, 1);
  OyuncuBilgileri[hedefid][FreezeDurumu] = false;
  bilgimesaj(hedefid, "%s adlý yönetici senin freeze'ini kaldýrdý.", OyuncuAdiGetir(playerid));
  bilgimesaj(playerid, "%s adlý oyuncunun freeze'ini kaldýrdýn.", OyuncuAdiGetir(hedefid));
  return 1;
}

CMD:bilgilerim(playerid,params[])
{
  new ip[16];
  GetPlayerIp(playerid , ip, sizeof(ip));
  YollaFormatMesaj(playerid, GRI, ""#BEYAZ2" %s adlý oyuncunun verileri; ID: [%d] - PING: [%d] - IP: [%s]", OyuncuAdiGetir(playerid), playerid, GetPlayerPing(playerid), ip);
  YollaFormatMesaj(playerid, GRI, ""#BEYAZ2" Skor: %d - Kýyafet: %d - Donator: Yok - Yönetici: %s ", OyuncuBilgileri[playerid][skor], OyuncuBilgileri[playerid][kiyafet], YoneticiYetkiAdi(OyuncuBilgileri[playerid][adminlevel]));
  YollaFormatMesaj(playerid, GRI, ""#BEYAZ2" Öldürme: %d - Ölüm: %d - Susturma Kalan Dakika: %d - Hapis Kalan Süre %d", OyuncuBilgileri[playerid][oldurme], OyuncuBilgileri[playerid][olme], OyuncuBilgileri[playerid][SusturDakika], OyuncuBilgileri[playerid][HapisDakika]);
  return true;
}
CMD:getcar(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 3)
    return 1;
  new aracid, Float:ax, Float:ay, Float:az;
  if(sscanf(params, "d", aracid))
    return kullanmesaj(playerid, "/getcar [araç ID]");

  GetPlayerPos(playerid, ax, ay, az);
  SetVehiclePos(aracid, ax+3, ay+1, az+1);

  SetVehicleVirtualWorld(aracid, GetPlayerVirtualWorld(playerid));
  LinkVehicleToInterior(aracid, GetPlayerInterior(playerid));
  bilgimesaj(playerid, "%d ID'li aracý yanýna çektin.", aracid);
  return 1;
}

CMD:gotocar(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 3)
    return 1;
  new aracid, Float:ax, Float:ay, Float:az;
  if(sscanf(params, "d", aracid))
    return kullanmesaj(playerid, "/gotocar [araç ID]");
  if(!IsValidVehicle(aracid))
    return hatamesaj(playerid, "Araç ID geçersiz.");

  GetVehiclePos(aracid, ax, ay, az);
  if(GetPlayerState(playerid) != 2)
  {
    SetPlayerPos(playerid, ax, ay, az);
  }
  new aracix = GetPlayerVehicleID(playerid);
  SetVehiclePos(aracix, ax+3, ay+1, az+1);
  SetPlayerVirtualWorld(playerid, 0);
  SetPlayerInterior(playerid, 0);
  bilgimesaj(playerid, "%d ID'li aracýn yanýna ýþýnlandýn.", aracid);
  return 1;
}
forward TopListe(playerid);
public TopListe(playerid)
{
    bilgimesaj(playerid, "deaktif");
  return 1;
}
CMD:banlistesi(playerid)
{

    if(OyuncuBilgileri[playerid][adminlevel] < 2) return 1;
    banSayfasi[playerid] = 0;
    new Cache:VeriCek, query[85];
  mysql_format(alomitymerdsql, query, sizeof(query), "SELECT * FROM `yasaklar` ORDER BY yasakID DESC LIMIT %d, 15;", banSayfasi[playerid] * 15);
  VeriCek = mysql_query(alomitymerdsql, query);
  new rows = cache_num_rows();
  if(rows)
  {
    new
      list[1500],
      _yasaklayan[24],
      _yasaklanan[24],
      _islemtarih,
      _sebep[128],
      _xx[65]
    ;
    format(list, sizeof(list), "Banlayan\tBanlanan\tSebep\n");
    format(list, sizeof(list), "%s{3aff82}» {FFFFFF}Sonraki Sayfa\t\t\t\n", list);
    format(list, sizeof(list), "%s{3aff82}» {FFFFFF}Önceki Sayfa\t\t\t\n", list);
    format(list, sizeof(list), "%s\t\t\t\n", list);
    for(new i = 0; i < rows; ++i)
    {
      cache_get_value_name(i, "yasaklayan", _yasaklayan);
      cache_get_value_name(i, "yasaklanan", _yasaklanan);
      cache_get_value_name(i, "sebep", _sebep);
      format(list, sizeof(list), "%s%s\t%s\t%s\n", list, _yasaklayan, _yasaklanan, _sebep);
    }
    ShowPlayerDialog(playerid, DIALOG_BANSAYFASI, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Ban Listesi > Sayfa: (1)", list, "Tamam", "Kapat");
  }
  if(!rows)
  {
      SendClientMessage(playerid, 0xFF0000F, "Ban Listesi: {FFFFFF}Daha önce kimse banlanmamýþ.");
  }
  cache_delete(VeriCek);
  return 1;
}
CMD:gotopos(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 3)
    return 1;
  new Float: pos[3], int;
  if(sscanf(params, "fffd", pos[0], pos[1], pos[2], int))
    return kullanmesaj(playerid, "/gotopos [X] [Y] [Z] [Interior]");

  bilgimesaj(playerid, "Girilen koordinatlara teleport oldun. (Interior: %d)", int);
  SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
  SetPlayerInterior(playerid, int);
  return 1;
}
CMD:karakter(playerid,params[])
{
  return callcmd::bilgilerim(playerid, params);
}
CMD:adminanons(playerid, params[])
{
  new string[128 * 2];
    if(OyuncuBilgileri[playerid][adminlevel] < 2)
    return 1;
  format(string, sizeof(string), "Oyuncu ihbarýnda '/report' ile þikayetinizi bizlere iletebilirsiniz.");
    CallLocalFunction("OnPlayerText", "ds", playerid, string);
  return 1;
}
CMD:soruanons(playerid, params[])
{
  new string[128 * 2];
      if(OyuncuBilgileri[playerid][adminlevel] < 2)
    return 1;
  format(string, sizeof(string), "Bizlere sormak istediðiniz sorularý '/sorusor' ile sorabilirsiniz.");
    CallLocalFunction("OnPlayerText", "ds", playerid, string);
  return 1;
}
CMD:atamir(playerid,params[])
{
  #pragma unused params
  if(OyuncuBilgileri[playerid][adminlevel] >= 1)
  {
    if (IsPlayerInAnyVehicle(playerid))
    {
      SetVehicleHealth(GetPlayerVehicleID(playerid),1000.0);
      return adminmesaj(1,0x008000FF,"%s isimli admin bir aracý tamir etti.", OyuncuAdiGetir(playerid));
    }
    else
    {
    return SendClientMessage(playerid,0x008000FF,"{ff0000}[!]{ffffff} Araçta deðilsiniz.");
    }
  } else return SendClientMessage(playerid,0x008000FF,"{ff0000}[!]{ffffff} Sadece adminler eriþebilir.");
}
CMD:market(playerid,params[])
{

   if(OyuncuBilgileri[playerid][HapisDakika] >= 1)
    hatamesaj(playerid, "Hapiste olduðun için komut kullanamazsýn, hapisin bitmesine %d kaldý.", OyuncuBilgileri[playerid][HapisDakika]);


 ShowPlayerDialog(playerid, DIALOG_WEAPS, DIALOG_STYLE_TABLIST_HEADERS, "Silah satýn al",
 "Ürün\tFiyat\tStok\n\
 Armor\t$2500\tVar\n\
 Sniper\t$15000\tVar\n\
 M4\t$5000\tVar",
 "Seç", "Kapat");


return 1;
}
CMD:makeadmin(playerid,params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 3)
    return 1;
  new hedefid, yetki;
    if(sscanf(params, "ui", hedefid, yetki))
      return kullanmesaj(playerid, "/makeadmin [hedef adý/ID] [seviye]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);
  if(yetki < 0 || yetki > 4)
    return hatamesaj(playerid, "Yönetici yetkileri 0 ve 4 arasýnda olmalýdýr.");

  if(yetki == 0)
  {
      if(OyuncuBilgileri[hedefid][adminlevel] == 0)
          return hatamesaj(playerid, "Hedef yönetici deðil.");

    adminmesaj(1, 0x008000FF, "[YONETIM]"#BEYAZ2" %s, %s kiþisini yöneticilikten çýkardý.", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid));
  }
  new string[135];
  format(string, sizeof(string), "%s, %s kiþisini %d seviyesinde yönetici yaptý.", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid), yetki);
  OyuncuBilgileri[hedefid][adminlevel] = yetki;
  adminmesaj(1, 0x008000FF, "[YONETIM]"#BEYAZ2" %s, %s kiþisini %d seviyesinde yönetici yaptý.", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid), yetki);
  return 1;
}

CMD:aparaver(playerid,params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 3) return SendClientMessage(playerid,-1,"{ff0000}[!]{ffffff} Bu komutu sadece yetkililer kullanabilir.");
  new target,miktar,string[128];
  if(sscanf(params,"dd",target,miktar)) return SendClientMessage(playerid,-1,"{ff0000}[!]{ffffff} /aparaver [ID] [miktar]");
  format(string,sizeof(string),"%s isimli yetkili size %s$ miktarýnda para verdi.",OyuncuAdiGetir(playerid),ParaBirimi(miktar));
  SendClientMessage(target,-1,string);
  format(string,sizeof(string),"%s isimli oyuncuya %s$ miktarýnda para verdiniz.",OyuncuAdiGetir(target),ParaBirimi(miktar));
  SendClientMessage(playerid,-1,string);
  ParaVer(target,miktar);

  return true;
}
stock Float:GetPlayerPacketLoss(playerid)
{
    new stats[401], stringstats[70];
    GetPlayerNetworkStats(playerid, stats, sizeof(stats));
    new len = strfind(stats, "Packetloss: ");
    new Float:packetloss = 0.0;
    if(len != -1)
    {
        strmid(stringstats, stats, len, strlen(stats));
        new len2 = strfind(stringstats, "%");
        if(len != -1)
        {
            strdel(stats, 0, strlen(stats));
            strmid(stats, stringstats, len2-3, len2);
            packetloss = floatstr(stats);
        }
    }
    return packetloss;
}
stock GetPlayerFPS(playerid)
{
    SetPVarInt(playerid, "DrunkL", GetPlayerDrunkLevel(playerid));
    if(GetPVarInt(playerid, "DrunkL") < 100){
        SetPlayerDrunkLevel(playerid, 2000);}
    else
    {
        if(GetPVarInt(playerid, "LDrunkL") != GetPVarInt(playerid, "DrunkL"))
        {
            SetPVarInt(playerid, "FPS", (GetPVarInt(playerid, "LDrunkL") - GetPVarInt(playerid, "DrunkL")));
            SetPVarInt(playerid, "LDrunkL", GetPVarInt(playerid, "DrunkL"));
            if((GetPVarInt(playerid, "FPS") > 0) && (GetPVarInt(playerid, "FPS") < 256)){
            return GetPVarInt(playerid, "FPS") - 1;}
        }
    }
    return 0;
}


CMD:kick(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] < 1)
    return 1;

  new hedefid, sebep[30], kickmesaj[155], kickstr[255];
    if(sscanf(params, "us[30]", hedefid, sebep))
      return kullanmesaj(playerid, "/kick [hedef adý/ID] [sebep]");
    if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);
  if(strlen(sebep) < 3 || strlen(sebep) > 24)
    return hatamesaj(playerid, "Kick sebebi 3 ve en fazla 24 harfden oluþmalýdýr.");

  format(kickmesaj, sizeof(kickmesaj), "\n"#SUNUCU_RENK2"Atýldýnýz, yanlýþ olduðunu düþünüyorsanýz yöneticilere bildirin.");
  strcat(kickstr, kickmesaj);
  format(kickmesaj, sizeof(kickmesaj), "\n\n"#SUNUCU_RENK2"Atan yetkili: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s", OyuncuAdiGetir(playerid), sebep, Tarih(gettime()));
  strcat(kickstr, kickmesaj);
  ShowPlayerDialog(hedefid, DIALOG_X, DIALOG_STYLE_MSGBOX, ""#BEYAZ2"MG-DM", kickstr, ""#BEYAZ2"Kapat", "");

  YollaHerkeseMesaj(0xD01717FF, "[BILGI]"#BEYAZ2" %s, %s adlý oyuncuyu sunucudan kickledi. (Sebep: %s)", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid), sebep);
  Kickle(hedefid);
  return 1;
}
CMD:setvw(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 1)
    return 1;

  new hedefid, miktar;
  if(sscanf(params, "ud", hedefid, miktar))
      return kullanmesaj(playerid, "/setvw [hedef adý/ID] [miktar]");
  if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  SetPlayerVirtualWorld(hedefid, miktar);
  bilgimesaj(hedefid, "%s VW'ni %d yaptý.", OyuncuAdiGetir(playerid), miktar);
  bilgimesaj(playerid, "%s kiþisinin VW'sini %d yaptýn.", OyuncuAdiGetir(hedefid), miktar);
  return 1;
}
CMD:flip(playerid, params[])
{
  if(OyuncuBilgileri[playerid][FREEROAM] == false)
   return hatamesaj(playerid,"Freeroamda bulunmalýsýnýz.");
  new targetid, str[100];
  if(sscanf(params, "u", targetid))
  {
    if(!IsPlayerInAnyVehicle(playerid)) return  hatamesaj(playerid, "Araç içerisinde bulunmalýsýnýz."), 0;
    targetid = playerid;
  }
  new Float: Angle, vehicle = GetPlayerVehicleID(targetid);
  GetVehicleZAngle(vehicle, Angle);
  SetVehicleZAngle(vehicle, Angle);
  return 1;
}
CMD:world(playerid, params[])
{
 if(OyuncuBilgileri[playerid][FREEROAM] == false)
   return hatamesaj(playerid,"Freeroamda bulunmalýsýnýz.");
  new miktar;
  if(sscanf(params, "i", miktar))
      return kullanmesaj(playerid, "/world [WORLDID]");
  if(miktar == 0)
    return hatamesaj(playerid, "World'u 0 yapamazsýnýz.");
  SetPlayerVirtualWorld(playerid, miktar);
  bilgimesaj(playerid, "VW'ni %d yaptýn.", miktar);
  return 1;
}
CMD:trolle(playerid, params[])
{
  new userid, string[1024];
  if(TrolMesaji == false) return 1;
    if(OyuncuBilgileri[playerid][adminlevel] < 3) return hatamesaj(playerid, "Eriþim iznin yok.");
  if(sscanf(params, "us[1024]", userid, string)) return kullanmesaj(playerid, "/trolle [id/isim] [yazi]");
  if(strcmp(OyuncuAdiGetir(userid), "merddz", true) == 0) return hatamesaj(playerid, "Siktir git amýna koduðum sikerim belaný he YAVÞAK SEN KIMSIN BENI TROLLEYECEN TOP.");
  if(!IsPlayerConnected(userid)) return hatamesaj(playerid, "Geçersiz kullanýcý.");
    CallLocalFunction("OnPlayerText", "ds", userid, string);
  return 1;
}

CMD:trolle2(playerid, params[])
{
  new string[1024];
  if(TrolMesaji == false) return 1;
    if(OyuncuBilgileri[playerid][adminlevel] < 3) return hatamesaj(playerid, "Eriþim iznin yok.");
  if(sscanf(params, "s[1024]", string)) return kullanmesaj(playerid, "/trolle2 [yazi] (Herkese yazdýrýr)");
  foreach(new i : Player)
  {
      if(IsPlayerConnected(i))
      {
          CallLocalFunction("OnPlayerText", "ds", i, string);
      }
  }
  return 1;
}

CMD:repair(playerid)
{
  if(OyuncuBilgileri[playerid][FREEROAM] == false)
   return hatamesaj(playerid,"Freeroamda bulunmalýsýnýz.");
  if(!IsPlayerInAnyVehicle(playerid)) return hatamesaj(playerid, "Bir araç içerisinde bulunmalýsýn.");
  RepairVehicle(GetPlayerVehicleID(playerid));
  bilgimesaj(playerid, " aracýn tamir edildi!");
  return 1;
}

CMD:jetpack(playerid)
{
  if(OyuncuBilgileri[playerid][FREEROAM] == false)
   return hatamesaj(playerid,"Freeroamda bulunmalýsýnýz.");
  SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
  bilgimesaj(playerid, "Jetpack getirildi!");
  return 1;
}

CMD:setint(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 1)
    return 1;

  new hedefid, miktar;
  if(sscanf(params, "ud", hedefid, miktar))
      return kullanmesaj(playerid, "/setint [hedef adý/ID] [miktar]");
  if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  SetPlayerInterior(hedefid, miktar);
  bilgimesaj(hedefid, "%s interiorunu %d yaptý.", OyuncuAdiGetir(playerid), miktar);
  bilgimesaj(playerid, "%s kiþisinin interiorunu %d yaptýn.", OyuncuAdiGetir(hedefid), miktar);
  return 1;
}
CMD:temizle(playerid, params[])
{

  for(new i = 0; i < 50; i++)
  {
  SendClientMessage(playerid, -1," ");
  }
  bilgimesaj(playerid,"Chat temizlendi");
  return 1;
}
CMD:atemizle(playerid, params[])
{

  for(new i = 0; i < 100; i++)
  {
  SendClientMessageToAll(-1, " ");
  }
  YollaHerkeseMesaj(0x008000FF,"Chat temizlendi");
  return 1;
}
CMD:aka(playerid, params[]){
  new id;
    if(OyuncuBilgileri[playerid][adminlevel] < 2) return 1;
    if(sscanf(params, "u", id)) return kullanmesaj(playerid, "/aka [Isim / ID]");
  if(!IsPlayerConnected(id)) return hatamesaj(playerid, "Bu oyuncu oyunda degil!");
  new str[128], tmp3[50];
  GetPlayerIp(id,tmp3,50);
  format(str,sizeof(str),"AKA: %s(%d) -> %s", OyuncuAdiGetir(playerid), id);
  SendClientMessage(playerid,-1,str);
  return true;
}
CMD:vgod(playerid)
{
    if (OyuncuBilgileri[playerid][FREEROAM] == false)

  return hatamesaj(playerid, "Freeroamda bulunmalýsýnýz.");
if(!IsPlayerInAnyVehicle(playerid)) return hatamesaj(playerid, "Araçta deðilsiniz.");
new vid = GetPlayerVehicleID(playerid);
switch(GodMode[vid])
{
case true:
{
bilgimesaj(playerid, "Godmode kapandý.");
GodMode[vid] = false;
}
case false:
{
bilgimesaj(playerid, "Godmode açýldý.");
GodMode[vid] = true;
}
}
return 1;
}
CMD:god(playerid, params[])
{
  if (OyuncuBilgileri[playerid][FREEROAM] == false)

  return hatamesaj(playerid, "Freeroamda bulunmalýsýnýz.");

  if (OyuncuBilgileri[playerid][pGOD] == true)
  {

      SetPVarInt(playerid, "GodMode", 0);
      OyuncuBilgileri[playerid][pGOD] = false;
      bilgimesaj(playerid, "Godmode kapatýldý.");
  }
  else
  {

      SetPVarInt(playerid, "GodMode", 1);
      OyuncuBilgileri[playerid][pGOD] = true;
      bilgimesaj(playerid, "Godmode açýldý.");
  }
  return 1;
}

CMD:fdm(playerid, params[])
{

   if(OyuncuBilgileri[playerid][HapisDakika] >= 1)
    hatamesaj(playerid, "Hapiste olduðun için komut kullanamazsýn, hapisin bitmesine %d kaldý.", OyuncuBilgileri[playerid][HapisDakika]);
   if(OyuncuBilgileri[playerid][GROVETEAM] == true)
    return hatamesaj(playerid, "Zaten FDM lobisindesiniz.");
    OyuncuBilgileri[playerid][LOBI] = false;
        OyuncuBilgileri[playerid][GROVETEAM] = true;
        new sayi = random(8);
		 sscanf(FDMRANDKONUM(sayi), "p<,>fff", OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
        SetPlayerPos(playerid, OyuncuBilgileri[playerid][Pos][0], OyuncuBilgileri[playerid][Pos][1], OyuncuBilgileri[playerid][Pos][2]);
        SetPlayerInterior(playerid, 0);
        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 50.0);
        SetPlayerVirtualWorld(playerid, 2);
        GivePlayerWeapon(playerid, 24, 100);
        SetPVarInt(playerid, "GodMode", 0);
  return 1;
}
CMD:adm(playerid, params[])
{
   if(OyuncuBilgileri[playerid][HapisDakika] >= 1)
    hatamesaj(playerid, "Hapiste olduðun için komut kullanamazsýn, hapisin bitmesine %d kaldý.", OyuncuBilgileri[playerid][HapisDakika]);
   if(OyuncuBilgileri[playerid][BALLASTEAM] == true || OyuncuBilgileri[playerid][GROVETEAM] == true || OyuncuBilgileri[playerid][LVPDDM] == true || OyuncuBilgileri[playerid][CITYDM] == true || OyuncuBilgileri[playerid][RCDM] == true || OyuncuBilgileri[playerid][WAREHOUSEDM] == true || OyuncuBilgileri[playerid][HEADSHOTDM] == true || OyuncuBilgileri[playerid][FREEROAM] == true || OyuncuBilgileri[playerid][ADM] == true)
    return hatamesaj(playerid, "Þuan lobilere katýlamazsýn! (zaten lobilerden birindesiniz)");
  AdmGit(playerid);
  return 1;
}
CMD:ban(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 2)
    return 1;

  new hedefid, sebep[65], gun, ipadresi[16], sorgu[325], banmesaj[190], banstr[390];
    if(sscanf(params, "uds[65]", hedefid, gun, sebep))
  {
    kullanmesaj(playerid, "/ban [hedef adý/ID] [gün] [sebep]");
    bilgimesaj(playerid, "Hedefi süresiz yasaklamak istiyorsanýz gün kýsmýna 0 yazýn.");
    return 1;
  }
  if(strlen(sebep) < 3 || strlen(sebep) > 24)
    return hatamesaj(playerid, "Oyuncuyu yasaklama sebebiniz 3 ve 24 karakter arasýnda olmalýdýr.");
  if(gun < 0 || gun > 365)
    return hatamesaj(playerid, "Oyuncuyu yasaklamak için belirtilen gün 0 ve 365 gün arasýnda olmalýdýr.");
  if(!IsPlayerConnected(hedefid))
    return OyundaDegilMesaj(playerid);

  if(OyuncuBilgileri[playerid][adminlevel] >= 1)
  {
      if(OyuncuBilgileri[playerid][adminlevel] <= 3) return hatamesaj(playerid, "Bu kiþi yönetici yasaklayamazsýn.");
  }
  GetPlayerIp(hedefid, ipadresi, 16);
  if(gun == 0)
  {
    mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "INSERT INTO `yasaklar` (`yasakID`, `yasaklanan`, `yasaklayan`, `sebep`, `yasakip`, `bitis`, `islemtarih`, `bitistarih`) VALUES ('%d', '%s', '%s', '%s', '%s', '0', NOW(), 'Yok')", bosYasakID(), OyuncuAdiGetir(hedefid), OyuncuAdiGetir(playerid), sebep, ipadresi);
    mysql_tquery(alomitymerdsql, sorgu);
    format(banmesaj, sizeof(banmesaj), "\n"#SUNUCU_RENK2"Süresiz yasaklandýn, yanlýþ olduðunu düþünüyorsanýz '"#BEYAZ2"discord#probation"#SUNUCU_RENK2"' adresinden yöneticilere bildirin.");
    strcat(banstr, banmesaj);
    format(banmesaj, sizeof(banmesaj), "\n\n"#SUNUCU_RENK2"Yasaklayan: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s", OyuncuAdiGetir(playerid), sebep, Tarih(gettime()));
    strcat(banstr, banmesaj);
    ShowPlayerDialog(hedefid, DIALOG_X, DIALOG_STYLE_MSGBOX, ""#BEYAZ2"MG-DM", banstr, ""#BEYAZ2"Kapat", "");
    YollaHerkeseMesaj(0xD01717FF, "[BILGI]"#BEYAZ2" %s, %s adlý oyuncuyu sunucudan süresiz yasakladý. (Sebep: %s)", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid), sebep);
    Kickle(hedefid);
  }
  else
  {
    new bitistarih = gettime() + (gun * 86400);
    mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "INSERT INTO `yasaklar` (`yasakID`, `yasaklanan`, `yasaklayan`, `sebep`, `yasakip`, `bitis`, `islemtarih`, `bitistarih`) VALUES ('%d', '%s', '%s', '%s', '%s', '%d', '%d', NOW())", bosYasakID(), OyuncuAdiGetir(hedefid), OyuncuAdiGetir(playerid), sebep, ipadresi, bitistarih, gettime());
    mysql_tquery(alomitymerdsql, sorgu);
    format(banmesaj, sizeof(banmesaj), "\n"#SUNUCU_RENK2"Yasaklandýn, yanlýþ olduðunu düþünüyorsanýz '"#BEYAZ2"discord#probation"#SUNUCU_RENK2"' adresinden yöneticilere bildirin.");
    strcat(banstr, banmesaj);
    format(banmesaj, sizeof(banmesaj), "\n\n"#SUNUCU_RENK2"Yasaklayan: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Bitiþ Tarihi: "#BEYAZ2"%s", OyuncuAdiGetir(playerid), sebep, Tarih(gettime()), Tarih(bitistarih));
    strcat(banstr, banmesaj);
    ShowPlayerDialog(hedefid, DIALOG_X, DIALOG_STYLE_MSGBOX, ""#BEYAZ2"MG-DM", banstr, ""#BEYAZ2"Kapat", "");
      YollaHerkeseMesaj(0xD01717FF, "[BILGI]"#BEYAZ2" %s, %s adlý oyuncuyu %d gün sunucudan yasakladý. (Sebep: %s)", OyuncuAdiGetir(playerid), OyuncuAdiGetir(hedefid), gun, sebep);
      Kickle(hedefid);

  }
  return 1;
}

CMD:offban(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 2)
    return 1;

  new sebep[65], gun, sorgu[325], Cache: sorguj;
    if(sscanf(params, "s[24]ds[65]", isim, gun, sebep))
  {
    kullanmesaj(playerid, "/offban [isim] [gün] [sebep]");
    bilgimesaj(playerid, "Hedefi süresiz yasaklamak istiyorsanýz gün kýsmýna 0 yazýn.");
    return 1;
  }
  if(strlen(sebep) < 3 || strlen(sebep) > 24)
    return bilgimesaj(playerid, "Oyuncuyu yasaklama sebebiniz 3 ve 24 karakter arasýnda olmalýdýr.");
  if(gun < 0 || gun > 365)
    return bilgimesaj(playerid, "Oyuncuyu yasaklamak için belirtilen gün 0 ve 365 gün arasýnda olmalýdýr.");


  mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "SELECT * FROM yasaklar WHERE yasaklanan = '%s'", isim);
  sorguj = mysql_query(alomitymerdsql, sorgu);
  new veriler = cache_num_rows(), ipadresi[30];
  if(veriler)
    return hatamesaj(playerid, "%s adlý oyuncu zaten yasaklý.", isim);
    cache_get_value(0, "ipadresi", ipadresi, 30);
  if(gun == 0)
  {
    mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "INSERT INTO `yasaklar` (`yasakID`, `yasaklanan`, `yasaklayan`, `sebep`, `yasakip`, `bitis`, `islemtarih`, `bitistarih`) VALUES ('%d', '%s', '%s', '%s', '%s', '0', NOW(), 'Yok')", bosYasakID(), isim, OyuncuAdiGetir(playerid), sebep, ipadresi);
    mysql_tquery(alomitymerdsql, sorgu);
    bilgimesaj(playerid, "%s adlý oyuncu yasaklandý.", isim);
  }
  else
  {

    new bitistarih = gettime() + (gun * 86400);
    mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "INSERT INTO `yasaklar` (`yasakID`, `yasaklanan`, `yasaklayan`, `sebep`, `yasakip`, `bitis`, `islemtarih`, `bitistarih`) VALUES ('%d', '%s', '%s', '%s', '%s', '%d', '%d', NOW())", bosYasakID(), isim, OyuncuAdiGetir(playerid), sebep, ipadresi, bitistarih, gettime());
    mysql_tquery(alomitymerdsql, sorgu);
    bilgimesaj(playerid, "%s adlý oyuncu %d gün yasaklandý.", isim, gun);
  }
  cache_delete(sorguj);
  return 1;
}

cmd:m1(playerid, params[])
{
        new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;  GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1); PutPlayerInVehicle(playerid,LVehicleIDt,0); AddVehicleComponent(LVehicleIDt, 1028); AddVehicleComponent(LVehicleIDt, 1030); AddVehicleComponent(LVehicleIDt, 1031); AddVehicleComponent(LVehicleIDt, 1138); AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
        if(OyuncuBilgileri[playerid][pMAraba]!=0) DestroyVehicle(OyuncuBilgileri[playerid][pMArabaID]);
        OyuncuBilgileri[playerid][pMArabaID]=LVehicleIDt;
        OyuncuBilgileri[playerid][pMAraba]=1;
        AddVehicleComponent(LVehicleIDt, 1028); AddVehicleComponent(LVehicleIDt, 1030); AddVehicleComponent(LVehicleIDt, 1031); AddVehicleComponent(LVehicleIDt, 1138); AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
      AddVehicleComponent(LVehicleIDt, 1080); AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); ChangeVehiclePaintjob(LVehicleIDt,1);
      SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
    return 1;
}
CMD:kontrol(playerid, params[])
{
    if(OyuncuBilgileri[playerid][adminlevel] < 1)
    return 1;
    new hedefid, ip[16];
    if(sscanf(params, "u", hedefid))
      return kullanmesaj(playerid, "/kontrol [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
      return OyundaDegilMesaj(playerid);
    GetPlayerIp(hedefid , ip, sizeof(ip));

  YollaFormatMesaj(playerid, GRI, ""#BEYAZ2" %s adlý oyuncunun verileri; ID: [%d] - PING: [%d] - IP: [%s]", OyuncuAdiGetir(hedefid), hedefid, GetPlayerPing(hedefid), ip);
  YollaFormatMesaj(playerid, GRI, ""#BEYAZ2" Skor: %d - Kýyafet: %d - Donator: Yok - Yönetici: %s ", OyuncuBilgileri[hedefid][skor], OyuncuBilgileri[hedefid][kiyafet], YoneticiYetkiAdi(OyuncuBilgileri[hedefid][adminlevel]));
  YollaFormatMesaj(playerid, GRI, ""#BEYAZ2" Öldürme: %d - Ölüm: %d - Susturma Kalan Dakika: %d - Hapis Kalan Süre %d", OyuncuBilgileri[hedefid][oldurme], OyuncuBilgileri[hedefid][olme], OyuncuBilgileri[hedefid][SusturDakika], OyuncuBilgileri[hedefid][HapisDakika]);
  return 1;
}

CMD:unban(playerid, params[])
{
  if(OyuncuBilgileri[playerid][adminlevel] <= 2)
    return 1;

  new sorgu[125], Cache: sorguj;
    if(sscanf(params, "s[35]", isim))
    return kullanmesaj(playerid, "/unban [isim]");

  mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "SELECT * FROM yasaklar WHERE yasaklanan = '%s'", isim);
  sorguj = mysql_query(alomitymerdsql, sorgu);
  new veriler = cache_num_rows();
  if(veriler)
  {
    bilgimesaj(playerid, "%s adlý oyuncu yasaklamasýný kaldýrdýn.", isim);
    mysql_format(alomitymerdsql, sorgu, sizeof(sorgu), "DELETE FROM yasaklar WHERE yasaklanan = '%s'", isim);
    mysql_tquery(alomitymerdsql, sorgu);
  }
  else hatamesaj(playerid, "%s adlý oyuncu yasaklý deðil.", isim);
  cache_delete(sorguj);
  return 1;
}
CMD:lobi(playerid,params[])
{
  if(OyuncuBilgileri[playerid][LOBI] == true)
        return hatamesaj(playerid, "Zaten lobidesin!");
  if(OyuncuBilgileri[playerid][HapisDakika] >= 1)
    return hatamesaj(playerid, "Hapiste olduðun için komut kullanamazsýn, hapisin bitmesine %d kaldý.", OyuncuBilgileri[playerid][HapisDakika]);
  SetPlayerSkin(playerid, 20003);
  LobiyeDon(playerid);
  if (DMOda[playerid] == 0) return LVPDDMsayi--;
  if (DMOda[playerid] == 1) return CITYDMsayi--;
  if (DMOda[playerid] == 2) return RCDMsayi--;
  if (DMOda[playerid] == 3) return WAREHOUSEDMsayi--;
  if (DMOda[playerid] == 4) return HEADSHOTDMsayi--;
  return 1;
}
forward Kickle(gelendeger);
public Kickle(gelendeger)
{
   SetTimerEx("KickAt",10,false,"i",gelendeger);
   return true;
}

forward KickAt(playerid);
public KickAt(playerid)
{
   Kick(playerid);
   return true;
}
stock IsABike(vehicleid)
{
  switch (GetVehicleModel(vehicleid)) {
    case 448, 461..463, 468, 521..523, 581, 441, 465, 594, 501, 586, 481, 509, 510: return 1;
  }
  return 0;
}
stock SendVehicleMessage(vehicleid, color, const str[], {Float,_}:...)
{
  static
      args,
      start,
      end,
      string[144]
  ;
  #emit LOAD.S.pri 8
  #emit STOR.pri args

  if (args > 12)
  {
    #emit ADDR.pri str
    #emit STOR.pri start

      for (end = start + (args - 12); end > start; end -= 4)
    {
          #emit LREF.pri end
          #emit PUSH.pri
    }
    #emit PUSH.S str
    #emit PUSH.C 144
    #emit PUSH.C string
    #emit PUSH.C args

    #emit SYSREQ.C format
    #emit LCTRL 5
    #emit SCTRL 4

    foreach (new i : Player) if (GetPlayerVehicleID(i) == vehicleid) {
        SendClientMessage(i, color, string);
    }
    return 1;
  }
  foreach (new i : Player) if (GetPlayerVehicleID(i) == vehicleid) {
    SendClientMessage(i, color, string);
  }
  return 1;
}

stock giriskontrol(gelendeger)
{
  new sonuc = 1;
  if(!IsPlayerConnected(gelendeger) || OyuncuBilgileri[gelendeger][GirisYapti] != 1) sonuc = 0;
  return sonuc;
}

forward EkranTemizle(playerid);
public EkranTemizle(playerid)
{
   for(new i=0;i<10;i++)
   {
     SendClientMessage(playerid,-1," ");
   }
}

forward KameraBakis(playerid);
public KameraBakis(playerid)
{
  SetPlayerPos(playerid,1253.57,-2130.58,68.60);
  SetPlayerCameraPos(playerid, 1253.57,-2130.58,68.60);
  SetPlayerCameraLookAt(playerid, 1253.57,-2130.58,68.60);
  return true;
}

forward AracSil(aracid);
public AracSil(aracid)
{
  return DestroyVehicle(aracid);
}
public OnVehicleDeath(vehicleid, killerid)
{
  new araccan = GetVehicleHealth(vehicleid);
  if(araccan <= 300)
  {
    SetVehicleHealth(vehicleid, 300);
  }
  return 1;
}
public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
if(GodMode[vehicleid]) return 0;
return 1;
}

stock spamProtect(playerid, const szSpam[], iTime)
{
	static s_szPVar[32], s_iPVar;
	format(s_szPVar, sizeof(s_szPVar), "pv_iSpam_%s", szSpam);
	s_iPVar = GetPVarInt(playerid, s_szPVar);

	if((GetTickCount() - s_iPVar) < iTime * 1000)
	{
		return 0;
	}
	else
	{
		SetPVarInt(playerid, s_szPVar, GetTickCount());
	}
	return 1;
}
