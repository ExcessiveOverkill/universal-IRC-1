{$IFDEF SOFTDMC}
  {$I MOTCON5}
  {$DEFINE FIFO}
{$ELSE}
  {$IFDEF THREEC20}
    {$DEFINE EEPROM}
    {$I MOTCOND.PAS}
    {$DEFINE FIFO}
  {$ELSE}
    {$IFDEF EIGHTI20}
      {$I 8I20con.PAS}
      {$DEFINE EEPROM}
    {$ELSE}
      {$IFDEF SEVENI43}
        {$I MOTCON5.PAS}
        {$DEFINE FIFO}
      {$ELSE}
        {$IFDEF EIGHTC20}
          {$I 8C20CON.PAS}
          {$DEFINE EEPROM}
        {$ELSE}
          {$IFDEF EIGHTI40}
            {$I MOTBITSD.PAS}
            {I 8I40BITS.PAS}
            {$DEFINE EEPROM}
          {$ELSE}
            {$IFDEF SEVENI64}
              {$I 7I64con.PAS}
              {$IFDEF GENERIC}
                {}
                {$DEFINE EEPROM}
              {$ELSE}

              {BUMOUT CARD NOT DEFINED }
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
