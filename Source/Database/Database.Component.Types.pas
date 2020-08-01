unit Database.Component.Types;

interface

uses
  Datasnap.Provider,
  FireDAC.Comp.Client;

type
  TDBConnection = TFDConnection;
  TDBData = TFDQuery;
  TDBDataProvider = TDataSetProvider;
  TDBStoredProcedure = TFDStoredProc;
  TDBTransaction = TFDTransaction;

implementation

end.
