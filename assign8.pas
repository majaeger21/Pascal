program assign8;

{ Added mutually recusive typing required me to do this pointer business with the ^}
type
    ExprC = ^ExprCRec; 
    NumC = record
       n : integer; 
    end;
    
    
    StrC = record
       s : String;
    end;
    
    IfC = record
      bool : ExprC;
      tru : ExprC;
      fls : ExprC;
    end;

{ Creates Union Type where exp attribute corresponds to type contained within ExprC}
ExprCRec = record
    case exp: Integer of
      1: (Num: NumC);
      2: (Str: StrC);
      3: (IfExp: IfC);
  end;
  

type
NumV = record
   n : integer; 
end;

type
StrV = record
   s : String;
end;


{Value Type}
type
  Val = record
    case exp: Integer of
      1: (Num: NumV);
      2: (Str: StrV);
  end;

{ Prints what type ExprC is holding }
function GetExp(U: ExprC): String;
begin
  case U^.Exp of
    1: GetExp := 'NumC';
    2: GetExp := 'StrC';
    3: GetExp := 'IfC';
  else
    GetExp := 'Unknown';
  end;
end;

{interp}
function interp(U : ExprC) : Val;
var
    result : Val; {result value that will be returned}
begin
    case U^.Exp of
    1: {NumC case}
        begin
            result.exp := 1;
            result.Num.n := U^.Num.n;
        end;
    2: {StrC Case}
        begin
            result.exp := 2;
            result.Str.s := U^.Str.s;
        end;
    end;
    interp := result; {return result}
end;

{regular code for testing}
var
    E1: ExprC;
    n1: NumC;
    E2: ExprC;
    s2: StrC;
    iftest: IfC;
    E4: ExprC;

begin
    New(E1);
    New(E2);
    New(E4);
   n1.n := 30;
   E1^.exp := 1;
   E1^.Num := n1;
   writeln('Data type is  ', GetExp(E1));
   writeln('Attempt to print NumC, only val atm', E1^.Num.n);
   
   s2.s := 'hello world';
   E2^.exp := 2;
   E2^.Str := s2;


   writeln('E1 interpretted: ', interp(E1).Num.n);
   writeln('E2 interpretted: ', interp(E2).Str.s);
    
   n1.n := 30;
   E1^.exp := 1;
   E1^.Num := n1;
   
   E2^.exp := 2;
   s2.s := 'hello fucker';
   E2^.Str := s2;
   
   iftest.bool := E1;
   iftest.tru := E2;
   iftest.fls := E2;
   E4^.exp := 3;
   E4^.IfExp := iftest;
   
   writeln(GetExp(E1));
   writeln('Testing E1 - NumC ', E1^.Num.n);
   writeln(GetExp(E2));
   writeln('Testing E2 - StrC ', E2^.Str.s);
   writeln(GetExp(E4));
   writeln('Testing IfC bool ', GetExp(E4^.IfExp.bool), ' ', E4^.IfExp.bool^.Num.n);
   writeln('Testing IfC tru ', GetExp(E4^.IfExp.tru), ' ', E4^.IfExp.tru^.Str.s);
   writeln('Testing IfC fls ', GetExp(E4^.IfExp.fls), ' ', E4^.IfExp.fls^.Str.s);
    Dispose(E1);
    Dispose(E2);
    Dispose(E4);
end.