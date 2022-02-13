
{$IFDEF SOFTDMC}
  {$I parmrec5}
  {$DEFINE FIFO}
{$ELSE}
  {$IFDEF THREEC20}
    {$I parmrecD}
    {$DEFINE EEPROM}
  {$ELSE}
    {$IFDEF EIGHTI20}
      {$I 8I20PREC.PAS}
      {$DEFINE EEPROM}
    {$ELSE}
      {$IFDEF SEVENI43}
        {$I Parmrec5.PAS}
        {$DEFINE FIFO}
      {$ELSE}
        {$IFDEF EIGHTC20}
          {$I 8C20PREC.PAS}
          {$DEFINE EEPROM}
        {$ELSE}
          {$IFDEF EIGHTI40}
            {$I 8I40PREC.PAS}
            {$DEFINE EEPROM}
        {$ELSE}
            {$IFDEF SEVENI64}
              {$I 7I64PREC.PAS}
            {$ELSE}
              {$IFDEF GENERIC}
                {$DEFINE EEPROM}
                {$I GENERICP.PAS}
              {$ELSE}
                {$IFDEF GENPIC}
                  {$DEFINE EEPROM}
                  {$I GENPICP.PAS}
                {$ELSE}
                  BUMOUT CARD NOT DEFINED
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
