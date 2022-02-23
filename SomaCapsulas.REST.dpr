program SomaCapsulas.REST;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  SomaCapsulas.REST.Constants in 'SomaCapsulas.REST.Constants.pas',
  SomaCapsulas.REST.Exception in 'SomaCapsulas.REST.Exception.pas',
  SomaCapsulas.REST.Interfaces in 'SomaCapsulas.REST.Interfaces.pas',
  SomaCapsulas.REST.Message in 'SomaCapsulas.REST.Message.pas',
  SomaCapsulas.REST.TTypes in 'SomaCapsulas.REST.TTypes.pas',
  SomaCapsulas.REST.Source.Client in 'source\SomaCapsulas.REST.Source.Client.pas',
  SomaCapsulas.REST.Source.Facade in 'source\SomaCapsulas.REST.Source.Facade.pas',
  SomaCapsulas.REST.Source.Request in 'source\SomaCapsulas.REST.Source.Request.pas',
  SomaCapsulas.REST.Source.Response in 'source\SomaCapsulas.REST.Source.Response.pas',
  SomaCapsulas.REST.Source.Factory.Client in 'source\factory\SomaCapsulas.REST.Source.Factory.Client.pas',
  SomaCapsulas.REST.Source.Builder.Request in 'source\builder\SomaCapsulas.REST.Source.Builder.Request.pas',
  SomaCapsulas.REST.Source.Adapter.Native.Core in 'source\adapter\native\SomaCapsulas.REST.Source.Adapter.Native.Core.pas',
  SomaCapsulas.REST.Source.Adapter.Indy.Factory.Command in 'source\adapter\indy\factory\SomaCapsulas.REST.Source.Adapter.Indy.Factory.Command.pas',
  SomaCapsulas.REST.Source.Adapter.Indy.Command in 'source\adapter\indy\SomaCapsulas.REST.Source.Adapter.Indy.Command.pas',
  SomaCapsulas.REST.Source.Adapter.Indy.Core in 'source\adapter\indy\SomaCapsulas.REST.Source.Adapter.Indy.Core.pas';

var
  LReadLnToWait: string;
begin
  try
    Writeln('SOMA Cápsulas - REST');
    Writeln(EmptyStr);
    Writeln('         .     .             ');
    Writeln('        (>\---/<)            ');
    Writeln('        ,''     `.           ');
    Writeln('       /  q   p  \           ');
    Writeln('      (  >(_Y_)<  )          ');
    Writeln('       >-'' `-'' `-<-.       ');
    Writeln('      /  _.== ,=.,- \        ');
    Writeln('     /,    )`  ''(    )      ');
    Writeln('    ; `._.''      `--<       ');
    Writeln('   :     \        |  )       ');
    Writeln('   \      )       ;_/  hjw   ');
    Writeln('    `._ _/_  ___.''-\\\      ');
    Writeln('       `--\\\                ');
    Read(LReadLnToWait);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
