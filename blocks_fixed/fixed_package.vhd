library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fda_package.all;

package fixed_package is
--------------------- Type declaration --------------------
  subtype fixed is std_logic_vector(MSB+LSB-1 downto 0);
  -------------------- Functions -----------------
  function "*" (A : fixed; B : fixed) return fixed;
  function "+" (A : fixed; B : fixed) return fixed;
  function "-" (A : fixed; B : fixed) return fixed;
  function shift_right (A : fixed; QT : integer) return fixed;
  function shift_leftF (A : fixed; QT : integer) return fixed;

end fixed_package;

package body fixed_package is

  function "*" (A : fixed; B : fixed) return fixed is
    variable v_MULT    : unsigned(2*(MSB+LSB)-1 downto 0);
    variable v_RESULT  : unsigned(2*(MSB+LSB)-1 downto 0);
  begin
    v_MULT := unsigned(A) * unsigned(B);
    v_RESULT := shift_right(v_MULT, LSB); -- TESTAR LSB-1 
    return fixed(resize(v_RESULT, MSB+LSB));
  end function;

    function "+" (A : fixed; B : fixed) return fixed is
      variable v_SUM : unsigned(MSB+LSB downto 0);
    begin
      v_SUM := resize(unsigned(A), MSB+LSB+1) + resize(unsigned(B), MSB+LSB+1);
     return fixed(resize(v_SUM, MSB+LSB));
    end function;

    function "-" (A : fixed; B : fixed) return fixed is
      variable v_SUM : unsigned(MSB+LSB-1 downto 0);
    begin
      v_SUM := unsigned(A) - unsigned(B);
      return fixed(v_SUM);
    end function;

    function shift_right (A : fixed; QT : integer) return fixed is
     begin
       return fixed(shift_right(unsigned(A), QT));
     end function;

   function shift_leftF (A : fixed; QT : integer) return fixed is
   begin
     return fixed(shift_left(unsigned(A), QT));
   end function;


end fixed_package;
