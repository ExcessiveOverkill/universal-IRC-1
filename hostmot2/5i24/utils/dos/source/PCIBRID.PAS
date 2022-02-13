{$I 9030}
{$I 9054}
{$I 9056}
{$I MesaPCI}
{$I XIO2001}
function SetupPCIWithMessage(cardnum : word;var base : word; var message : string) : boolean;
var
busnum,devnum: byte;
configbase : word;
FoundPCIBridge : boolean;
hstring : string;
begin
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(N030DeviceID,N030VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress2,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        hstring := HexString(base,4);
        message := 'Found 9030 based PCI card -- base address is: 0x'+hstring;
      end;
    end;
  end;
  if FindPCIDevice(N054DeviceID,N054VendorID,cardnum,busnum,devnum) then
  begin
    if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress2,ConfigBase) then
    begin
      ConfigBase := ConfigBase and $FFFE;
      base := ConfigBase;
      FoundPCIBridge := true;
      hstring := HexString(base,4);
      message := 'Found 9054 based PCI card -- base address is: 0x'+hstring;
    end;
  end;
  if FindPCIDevice(N056DeviceID,N056VendorID,cardnum,busnum,devnum) then
  begin
    if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress2,ConfigBase) then
    begin
      ConfigBase := ConfigBase and $FFFE;
      base := ConfigBase;
      FoundPCIBridge := true;
      hstring := HexString(base,4);
      message := 'Found 9056 based PCI card -- base address is: 0x'+hstring;
    end;
  end;
  if FoundPCIBridge = false then message := 'Didn''t find any PCI cards';
  SetupPCIWithMessage := FoundPCIBridge;
  { we really should look for the secondary ID for 5I20, 4I65, 5I21, 4I68 etc}
end;

function SetupPCI(cardnum: word; var base : word) : boolean;
var
busnum,devnum: byte;
configbase : word;
FoundPCIBridge : boolean;
hstring : string;
begin
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(N030DeviceID,N030VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress2,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        hstring := HexString(base,4);
        Writeln('Found 9030 based PCI card -- base address is: 0x'+hstring);
      end;
    end;
    if FindPCIDevice(N054DeviceID,N054VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress2,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        hstring := HexString(base,4);
        Writeln('Found 9054 based PCI card -- base address is: 0x'+hstring);
      end;
    end;
    if FindPCIDevice(N056DeviceID,N056VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress2,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        hstring := HexString(base,4);
        Writeln('Found 9056 based PCI card -- base address is: 0x'+hstring);
      end;
    end;
  end;
  if FoundPCIBridge = false then Writeln('Didn''t find any PCI cards');
  SetupPCI := FoundPCIBridge;
  { we really should look for the secondary ID for 5I20, 4I65, 5I21, 4I68 etc}
end;

function QuietSetupPCI(cardnum: word; var base : word) : boolean;
var
busnum,devnum: byte;
configbase : word;
FoundPCIBridge : boolean;
{hstring : string;}
begin
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(N030DeviceID,N030VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress2,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        {hstring := HexString(base,4);}
      end;
    end;
    if FindPCIDevice(N054DeviceID,N054VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress2,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        {hstring := HexString(base,4);}
      end;
    end;
    if FindPCIDevice(N056DeviceID,N056VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress2,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        {hstring := HexString(base,4);}
      end;
    end;
  end;
  QuietSetupPCI := FoundPCIBridge;
  { we really should look for the secondary ID for 5I20, 4I65, 5I21, 4I68 etc}
end;

function QuietSetupPCI_IO32(cardnum: word; var base : word) : boolean;
var
busnum,devnum: byte;
configbase : word;
FoundPCIBridge : boolean;
{hstring : string;}
begin
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(N030DeviceID,N030VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress3,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        {hstring := HexString(base,4);}
      end;
    end;
    if FindPCIDevice(N054DeviceID,N054VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress2,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        {hstring := HexString(base,4);}
      end;
    end;
    if FindPCIDevice(N056DeviceID,N056VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress2,ConfigBase) then
      begin
        ConfigBase := ConfigBase and $FFFE;
        base := ConfigBase;
        FoundPCIBridge := true;
        {hstring := HexString(base,4);}
      end;
    end;
  end;
  QuietSetupPCI_IO32 := FoundPCIBridge;
  { we really should look for the secondary ID for 5I20, 4I65, 5I21, 4I68 etc}
end;

function SetupPCIM(cardnum: word;var base : longint): boolean;
var
busnum,devnum: byte;
configbase : longint;
FoundPCIBridge : boolean;
hstring : string;
begin
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(N030DeviceID,N030VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress5,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress5+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
          hstring := HexString(base,8);
          Writeln('Found 9030 based PCI card -- memory base address is: 0x'+hstring);
        end;
      end;
    end;
    if FindPCIDevice(N4I74DeviceID,MesaVendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
          hstring := HexString(base,8);
          Writeln('Found Mesa 4I74 card -- memory base address is: 0x'+hstring);
        end;
      end;
    end;
    if FindPCIDevice(N5I24DeviceID,MesaVendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
          hstring := HexString(base,8);
          Writeln('Found Mesa 5I24 card -- memory base address is: 0x'+hstring);
        end;
      end;
    end;
    if FindPCIDevice(N5I25DeviceID,MesaVendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
          hstring := HexString(base,8);
          Writeln('Found Mesa 5I25 card -- memory base address is: 0x'+hstring);
        end;
      end;
    end;
    if FindPCIDevice(N6I25DeviceID,MesaVendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
          hstring := HexString(base,8);
          Writeln('Found Mesa 6I25 card -- memory base address is: 0x'+hstring);
        end;
      end;
    end;
    if FindPCIDevice(N054DeviceID,N054VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress3,LongIntRec(ConfigBase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress3+2,LongIntRec(ConfigBase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
          hstring := HexString(base,8);
          Writeln('Found 9054 based PCI card -- memory base address is: 0x'+hstring);
        end;
      end;
    end;
    if FindPCIDevice(N056DeviceID,N056VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress3,LongIntRec(ConfigBase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress3+2,LongIntRec(ConfigBase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
          hstring := HexString(base,8);
          Writeln('Found 9056 based PCI card -- memory base address is: 0x'+hstring);
        end;
      end;
    end;
  end;
  if FoundPCIBridge = false then Writeln('Didn''t find any PCI cards');
  SetupPCIM := FoundPCIBridge;
  { we really should look for the secondary ID for 5I20, 4I65, 5I21, 4I68 etc}
end;

function SetupXIO2001(cardnum: word;var base : longint; var message : string): boolean;
var
busnum,devnum: byte;
configbase : longint;
FoundPCIBridge : boolean;
hstring : string;
begin
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(XIO2001DeviceID,XIO2001VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,XIO2001PCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,XIO2001PCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
          hstring := HexString(base,8);
          message := 'Found XIO2001Bridge card -- memory base address is: 0x'+hstring;
        end;
      end;
    end;
  end;
  if FoundPCIBridge = false then message :='Didn''t find a XIO2001';
  SetupXIO2001 := FoundPCIBridge;
end;

function QuietSetupPCIM(cardnum: word;var base : longint) : boolean;
var
busnum,devnum: byte;
configbase : longint;
FoundPCIBridge : boolean;
begin
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(N030DeviceID,N030VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress5,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress5+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        {  writeln('BaseAddress ');
          hexprint(base,8);
          writeln; }
        end;
      end;
    end;
    if FindPCIDevice(N4I74DeviceID,MesaVendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        end;
      end;
    end;
    if FindPCIDevice(N5I24DeviceID,MesaVendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        end;
      end;
    end;
    if FindPCIDevice(N5I25DeviceID,MesaVendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        end;
      end;
    end;
    if FindPCIDevice(N6I25DeviceID,MesaVendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,MesaPCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        end;
      end;
    end;
    if FindPCIDevice(N054DeviceID,N054VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress3,LongIntRec(ConfigBase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress3+2,LongIntRec(ConfigBase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        end;
      end;
    end;
    if FindPCIDevice(N056DeviceID,N056VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress3,LongIntRec(ConfigBase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress3+2,LongIntRec(ConfigBase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        end;
      end;
    end;
  end;
  QuietSetupPCIM := FoundPCIBridge;
  { we really should look for the secondary ID for 5I20, 4I65, 5I21, 4I68 etc}
end;

function QuietSetupPCIMC(cardnum: word;var base : longint) : boolean;
var
busnum,devnum: byte;
configbase : longint;
FoundPCIBridge : boolean;
begin
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(N030DeviceID,N030VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress0,LongIntRec(configbase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,N030PCIBaseAddress0+2,LongIntRec(configbase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        end;
      end;
    end;
    if FindPCIDevice(N054DeviceID,N054VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress0,LongIntRec(ConfigBase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,N054PCIBaseAddress0+2,LongIntRec(ConfigBase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        end;
      end;
    end;
    if FindPCIDevice(N056DeviceID,N056VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress0,LongIntRec(ConfigBase).LowWord) then
      begin
        if ReadPCIConfigWord(busnum,devnum,N056PCIBaseAddress0+2,LongIntRec(ConfigBase).HighWord) then
        begin
          base := ConfigBase;
          FoundPCIBridge := true;
        end;
      end;
    end;
  end;
  QuietSetupPCIMC := FoundPCIBridge;
  { we really should look for the secondary ID for 5I20, 4I65, 5I21, 4I68 etc}
end;

function ReadBridgeConfigWord(cardnum: word; regnum : word; var data : word): boolean;
var
busnum,devnum: byte;
tword,treg : word;
FoundPCIBridge : boolean;
begin
  treg := regnum;
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(N030DeviceID,N030VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,treg,tword) then
      begin
        FoundPCIBridge := true;
      end;
    end;
    if FindPCIDevice(N054DeviceID,N054VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,treg,tword) then
      begin
        FoundPCIBridge := true;
      end;
    end;
    if FindPCIDevice(N056DeviceID,N056VendorID,cardnum,busnum,devnum) then
    begin
      if ReadPCIConfigWord(busnum,devnum,treg,tword) then
      begin
        FoundPCIBridge := true;
      end;
    end;
  end;
  data := tword;
  ReadBridgeConfigWord := FoundPCIBridge;
end;

function WriteBridgeConfigWord(cardnum: word; regnum : word; data : word): boolean;
var
busnum,devnum: byte;
tword,treg : word;
FoundPCIBridge : boolean;
begin
  tword := data;
  treg := regnum;
  FoundPCIBridge := false;
  if PCIBIOSPresent then
  begin
    if FindPCIDevice(N030DeviceID,N030VendorID,cardnum,busnum,devnum) then
    begin
      if WritePCIConfigWord(busnum,devnum,treg,tword) then
      begin
        FoundPCIBridge := true;
      end;
    end;
    if FindPCIDevice(N054DeviceID,N054VendorID,cardnum,busnum,devnum) then
    begin
      if WritePCIConfigWord(busnum,devnum,treg,tword) then
      begin
        FoundPCIBridge := true;
      end;
    end;
    if FindPCIDevice(N056DeviceID,N056VendorID,cardnum,busnum,devnum) then
    begin
      if WritePCIConfigWord(busnum,devnum,treg,tword) then
      begin
        FoundPCIBridge := true;
      end;
    end;
  end;
  WriteBridgeConfigWord := FoundPCIBridge;
end;
