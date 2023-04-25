--  Test of Ada interface for TRNG (Cryptographic Co-Processor). Coded by Wojciech Lawren.

--  Copyright (C) 2020, Wojciech Lawren, All rights reserved.

--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
--  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
--  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
--  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
--  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
pragma Ada_2022;

with AUnit.Assertions; use AUnit.Assertions;

package body rdrand.test is
   use Ada.Containers;

   procedure Set_Up (T : in out Fixture) is
   begin
      for I in 1 .. idx loop
         T.M_V1.Append (randx);
      end loop;
      for E of T.M_V1 loop
         T.M_S1.Include (E);
      end loop;
      for I in 1 .. idx loop
         T.M_V2.Append (seedx);
      end loop;
      for E of T.M_V2 loop
         T.M_S2.Include (E);
      end loop;
   end Set_Up;

   procedure Tear_Down (T : in out Fixture) is
   begin
      T.M_S1.Clear;
      T.M_S2.Clear;
      T.M_V1.Clear;
      T.M_V2.Clear;
   end Tear_Down;

   procedure Test_Collision (T : in out Fixture) is
   begin
      Assert (T.M_V1.Length = T.M_V2.Length, "Assertion Length V1:V2 TC");
      Assert (T.M_V1.Length = T.M_S1.Length, "Assertion Length V1:S1 TC");
      Assert (T.M_V2.Length = T.M_S2.Length, "Assertion Length V2:S2 TC");
      Assert (T.M_S1.Contains (0) = False, "Assertion 0 S1 TC");
      Assert (T.M_S2.Contains (0) = False, "Assertion 0 S2 TC");
   end Test_Collision;

   procedure Test_Entropy (T : in out Fixture) is
   begin
      Assert (T.M_S1.Last_Element - T.M_S1.First_Element > rx'Last / 2, "Assertion LF S1 TE");
      Assert (T.M_S2.Last_Element - T.M_S2.First_Element > rx'Last / 2, "Assertion LF S2 TE");
      Assert (T.M_S1.Equivalent_Sets (T.M_S2) = False, "Assertion EQ S1:S2 TE");
      Assert (T.M_S1.Symmetric_Difference (T.M_S2).Length > T.M_S2.Length, "Assertion XOR S1S2 TE");
   end Test_Entropy;

end rdrand.test;
