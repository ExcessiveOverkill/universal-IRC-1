const
{PCI function identifier in AH }

PCI_Function_ID : byte = $B1;

{ PCI function number in AL }

PCI_BIOS_Present : byte = $01;
PCI_Find_PCI_Device : byte = $02;
PCI_Find_PCI_ClassCode : byte = $03;
PCI_Generate_Special_Cycle : byte = $06;
PCI_Read_Config_Byte : byte = $08;
PCI_Read_Config_Word : byte = $09;
PCI_Read_Config_DWord : byte = $0A;
PCI_Write_Config_Byte : byte = $0B;
PCI_Write_Config_Word : byte = $0C;
PCI_Write_Config_DWord : byte = $0D;
PCI_Get_IRQ_Routing_Options : byte = $0E;
PCI_Set_PCI_IRQ : byte = $0F;

{ function results in AH }

PCI_Result_Successful : byte = $00;
PCI_Function_Not_Supported : byte = $81;
PCI_Bad_Vendor_ID : byte = $83;
PCI_Device_Not_Found : byte = $86;
PCI_Bad_Register_Number : byte = $87;
PCI_Set_Failed : byte = $88;
PCI_Buffer_Too_Small : byte = $89;

PCIStr : word = $4350; {'CP'}

{PCI Command register bits }
PCICommandRegOffset = 4;
PCICommandRegIOEnable : word = $0001;
PCICommandRegMEMEnable : word = $0002;
PCICommandRegMasterEnable : word = $0004;

function PCIBIOSPresent : boolean;
var flag : boolean;
begin
  asm
    mov ah,PCI_Function_ID
    mov al,PCI_BIOS_Present
    int $1A
    mov flag,false;
    or  ah,ah
    jnz @exit
    cmp dx,PCIStr;
    jnz @exit
    mov flag,true
    @exit:
  end;
  PCIBIOSPresent := flag;
end;

function FindPCIDevice(deviceid,vendorid,index : word;var busnum,devnum: byte) : boolean;
var
flag : boolean;
lbusnum,ldevnum : byte;

begin
  asm
    mov ah,PCI_Function_ID
    mov al,PCI_Find_PCI_Device
    mov cx,deviceid
    mov dx,vendorid
    mov si,index
    int $1A
    mov flag,false;
    or  ah,ah
    jnz @exit
    mov lbusnum,bh
    mov ldevnum,bl
    mov flag,true
    @exit:
  end;
  busnum := lbusnum;
  devnum := ldevnum;
  FindPCIDevice := flag;
end;

function ReadPCIConfigWord(busnum,devnum: byte;regnum:word; var configdata :word) : boolean;
var
flag : boolean;
lbusnum,ldevnum : byte;
lregnum,lconfigdata : word;

begin
  lbusnum := busnum;
  ldevnum := devnum;
  lregnum := regnum;
  asm
    mov ah,PCI_Function_ID
    mov al,PCI_Read_Config_Word
    mov bh,lbusnum
    mov bl,ldevnum
    mov di,lregnum
    int $1A
    mov flag,false;
    or  ah,ah
    jnz @exit
    mov lconfigdata,cx
    mov flag,true
    @exit:
  end;
  configdata := lconfigdata;
  ReadPCIConfigWord := flag;
end;

function WritePCIConfigWord(busnum,devnum: byte;regnum:word;configdata :word) : boolean;
var
flag : boolean;
lbusnum,ldevnum : byte;
lregnum,lconfigdata : word;

begin
  lbusnum := busnum;
  ldevnum := devnum;
  lregnum := regnum;
  lconfigdata := configdata;
  asm
    mov ah,PCI_Function_ID
    mov al,PCI_Write_Config_Word
    mov bh,lbusnum
    mov bl,ldevnum
    mov di,lregnum
    mov cx,lconfigdata
    int $1A
    mov flag,false;
    or  ah,ah
    jnz @exit
    mov flag,true
    @exit:
  end;
  WritePCIConfigWord := flag;
end;

