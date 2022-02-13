const
  CR = chr(13);
  NAK = '?';
  FlashBlockSize = 4096;
{$IFDEF EIGHTI20}
  GroupSize = 512*4;
{$ELSE}
  GroupSize = 32*4;
{$ENDIF}

  SerReadPicWordCom =      'RW';
  SerReadChecksumCom =     'RC';
  SerReadEEPROMCom =       'RE';
  SerReadFlashCom =        'RF';
  SerReadProtectCom =      'RP';
  SerReadROMCom =          'RR';
  SerReadGroupCom =        'RG';

  SerReadIFIFOCom =        'RI';
  SerReadQFIFOCom =        'RQ';
  SerReadIFIFOMultipleCom ='RM';
  SerReadQFIFOMultipleCom ='Rm';
  SerReadFIFOStatusCom =   'Rs';
  SerReadDirectWordCom =   'Rd'; { for fifoed interface }
  SerReadDirectByteCom =   'RD';
  SerReadStatusCom =       'RS';  { for PPM }
  SerReadAnalogCom =       'RA';  { for PPM }
  SerSelectChanCom =       'LS';  { for ppm }

  SerWriteFlashCom =       'WF';
  SerWriteProtectCom =     'WP';
  SerWriteOscCom     =     'WO';
  SerWriteROMCom =         'WR';
  SerWriteDirectWordCom =  'Wd';  { for fifoed interface }
  SerWriteDirectByteCom =  'WD';
  SerWriteGroupCom =       'WG';
  SerWriteEEPROMCom =      'WE';
  SerWritePicWordCom =     'WW';

  SerWriteIFIFOCom =       'WI';
  SerWriteQFIFOCom =       'WQ';

  SerEraseFlashCom =       'EF';
  SerEraseChecksumCom =    'EC';
  SerEraseGroupCom =       'EG';

  SerInquireIDCom  =       'II';
  SerInquireRevCom =       'IR';

  SerPICGoCom      =       'GP';
  SerConfigCom     =       'GC';

  SerClearICDFIFOCom =     'CI';   { not 7I60 yet }
  SerClearIRBFIFOCom =     'Ci';
  SerClearQCDFIFOCom =     'CQ';
  SerClearQRBFIFOCom =     'Cq';

  SerCountICDFIFOCom =     'cI';   { not 7I60 yet }
  SerCountIRBFIFOCom =     'ci';
  SerCountQCDFIFOCom =     'cQ';
  SerCountQRBFIFOCom =     'cq';

  SerWriteEEPROMWordCom =  'We';
  SerReadEEPROMWordCom =   'Re';
  SerListenCom =           'LS';
  SerMesaStartCom =        'MESASTART';
  SerMesaStopCom =         'MESASTOP';
