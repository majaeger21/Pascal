program assign8;

{Data Types}
type
NumC = record
   n : integer; 
end;

type
StrC = record
   s : String;
end;

type
NumV = record
   n : integer; 
end;

type
StrV = record
   s : String;
end;


{ Creates Union Type where exp attribute corresponds to type contained within ExprC}
type
  ExprC = record
    case exp: Integer of
      1: (Num: NumC);
      2: (Str: StrC);
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
  case U.Exp of
    1: GetExp := 'NumC';
    2: GetExp := 'StrC';
  else
    GetExp := 'Unknown';
  end;
end;

{interp}
function interp(U : ExprC) : Val;
var
    result : Val; {result value that will be returned}
begin
    case U.Exp of
    1: {NumC case}
        begin
            result.exp := 1;
            result.Num.n := U.Num.n;
        end;
    2: {StrC Case}
        begin
            result.exp := 2;
            result.Str.s := U.Str.s;
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

begin
   n1.n := 30;
   E1.exp := 1;
   E1.Num := n1;
   writeln('Data type is  ', GetExp(E1));
   writeln('Attempt to print NumC, only val atm', E1.Num.n);
   
   s2.s := 'hello world';
   E2.exp := 2;
   E2.Str := s2;


   writeln('E1 interpretted: ', interp(E1).Num.n);
   writeln('E2 interpretted: ', interp(E2).Str.s);

end.