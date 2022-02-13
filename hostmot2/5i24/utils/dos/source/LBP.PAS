const
{ Little Binary Protocol }
{ Copyright (C) 2008 MESA Electronics.  All rights reserved. }
{ TOKEN			VALUE	TYPE	FUNCTION }
{ Direct }
LBPADDDATA_byte          =      $0;             { Address or Data }
LBPCOMMAND_byte          =      $40;            { Command function }
LBPWRITE_byte            =      $20;            { Write command }
LBPD1_byte               =      $0;             { One byte data }
LBPD2_byte               =      $1;             { Two byte data }
LBPD4_byte               =      $2;             { Four byte data }
LBPD8_byte               =      $3;             { Eight byte data }
LBPA0_byte               =      $0;             { No address included, Last address used }
LBPA2_byte               =      $4;             { Two byte address included }
LBPINC_byte              =      $8;             { Increment address }
LBPRPCINCDATA_byte       =      $10;            { Write includes data within RPC }
{ FIFO Wait token for FIFO with timeout }
LBPFIFO_byte             =      $50;            { FIFO command }
LBPQRH_byte              =      $0;             { Wait for Queued Readback FIFO half full }
LBPQRE_byte              =      $1;             { Wait for Queued Readback FIFO not empty }
LBPIRH_byte              =      $2;             { Wait for Immediate Readback FIFO half full }
LBPIRE_byte              =      $3;             { Wait for Immediate Readback FIFO not empty }
LBPQFH_byte              =      $4;             { Wait for Queued Command/data FIFO not half full }
LBPQFF_byte              =      $5;             { Wait for Queued Command/data FIFO not full }
LBPIFH_byte              =      $6;             { Wait for Immediate Command/data FIFO not half full }
LBPIFF_byte              =      $7;             { Wait for Immediate Command/data FIFO not full }
{ Rpc }
LBPRPC_byte              =      $80;            { Rpc commands 0..63 }
LBPRPCEND_byte           =      $0;             { End of Rpc marker }
LBPLOCAL_byte            =      $C0;            { LBP Local Functions 0..31 }
{ LBP Local R/W locations Read at Cx Write at Ex }
LBPLISTEN_byte           =      $C0;            { Unit to listen }
LBPSTATUS_byte           =      $C1;            { Error status 0 for no errors }
LBPENACRC_flag           =      $C2;            { Non-zero to enable CRCs }
LBPCRCERRS_byte          =      $C3;            { Number of CRC errors }
{ LBPENASEQ	C4h	%flag	Non-zero to enable Sequence }
{ LBPSEQ		C5h	%byte	Sequence number }
LBPREMSWMODE_byte        =      $C6;            { Software mode of remote device }
LBPREMCLRFAULT_flag      =      $C7;            { Write true to clear faults, false when complete }
LBPRPCMEM_flag           =      $CA;            { Non-zero to allow access to RPC memory  }
LBPCHARTIMEOUT_byte      =      $CB;            { Command frame timeout in (n + 1 Milliseconds USB) }
LBPNONVOL_flag           =      $CC;            { Set to access Non Volatile memory }
{ LBP Special locations }
{ Read only }
LBPCARDNAME0_byte        =      $D0;            { Cardname character0, Read only }
LBPCARDNAME1_byte        =      $D1;            { Cardname character1, Read only }
LBPCARDNAME2_byte        =      $D2;            { Cardname character2, Read only }
LBPCARDNAME3_byte        =      $D3;            { Cardname character3, Read only }
LBPCAPABILITY_byte       =      $D4;            { Capability bits }
LBPREMREVISION_byte      =      $D5;            { Software revision of remote device }
LBPREMHWMODE_byte        =      $D6;            { Hardware Mode of remote device }
LBPREMFAULT_byte         =      $D7;            { Fault status of remote device }
LBPADDRESSL_byte         =      $D8;            { Current address Low byte, Read only }
LBPADDRESSH_byte         =      $D9;            { Current address High byte, Read only }
LBPVERSION_byte          =      $DA;            { Software Version, Read only }
LBPUNITID_byte           =      $DB;            { UnitId Read only 	 }
LBPRPCPITCH_byte         =      $DC;            { RPC pitch, Read only }
LBPRPCSIZEL_byte         =      $DD;            { RPC Memory size Low byte, Read only }
LBPRPCSIZEH_byte         =      $DE;            { RPC Memory size High byte, Read only }
LBPREADCOOKIE_byte       =      $DF;            { Returns 5Ah }
{ Write only }
{ LBPSETLOCK0	F0h	%byte	Reset by protected function }
{ LBPSETLOCK1	F1h	%byte	Reset by protected function }
{ LBPSETLOCK2	F2h	%byte	Reset by protected function }
{ LBPSETLOCK3	F3h	%byte	Reset by protected function }
LBPSETLEDS_byte          =      $F7;            { Set LEDS }
LBPSETADDRESSL_byte      =      $F8;            { Current address Low byte, Write only }
LBPSETADDRESSH_byte      =      $F9;            { Current address High byte, Write only }
LBPADDADDRESS_byte       =      $FA;            { Add byte to Current address, Write only }
LBPSETUNITID_byte        =      $FD;            { Non-Volatile Listen Unit ID, Write only  }
LBPPROCRESET_byte        =      $FE;            { Resets processor when 5A hex is written }
LBPWRITERESET_byte       =      $FF;            { Resets parser }
LBPFUNCTIONMASK_byte     =      $C0;            
LBPRWMASK_byte           =      $F0;            
LBPRPCNUMMASK_byte       =      $3F;            
LBPLOCALNUMMASK_byte     =      $1F;            
LBPLOCALSPECIAL_byte     =      $10;            
LBPFIFOSELMASK_byte      =      $7;             
LBPRESETCODE_byte        =      $5A;            { Must write this to reset }
LBPCOOKIECODE_byte       =      $5A;            { Returned by LBPREADCOOKIE }
LBPTRUE_flag             =      $FF;            { Byte true }
LBPFALSE_flag            =      $0;             { Byte false }
{ NonVol types }
LBPNONVOLEEPROM_byte     =      $1;             
LBPNONVOLFLASH_byte      =      $2;             
LBPFLASHERASE_byte       =      $FE;            
LBPFLASHWRITE_byte       =      $FD;            
LBPFLASHOFFSET_ptr       =      $8000;          
LBPFLASHERASESIZE_ptr    =      $8004;          
LBPFLASHWRITESIZE_ptr    =      $8005;          
LBPFLASHCOMMIT_ptr       =      $8007;          
{ Capability codes }
LBPCRCCAPABLE            =      $1;             
LBPFIFOCAPABLE           =      $2;             
LBPEEPROMCAPABLE         =      $4;             
LBPFLASHCAPABLE          =      $8;             
LBPINDIRECTCAPABLE       =      $10;            
{ LBP Status bits }
LBPCRCERR                =      $1;             
{ LBPTXCSUMERR		02h	 }
{ LBPSEQERR		04h }
LBPWDOGERR               =      $8;             
LBPBUFFERERR             =      $10;            
LBPINVALIDADDERR         =      $20;            { Access to protected memory or I/O }
LBPTIMEOUTERR            =      $40;            { Timeout waiting for complete Command }
LBPFIFOTIMEOUTERR        =      $80;            { Timeout waiting for FIFO }
