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
pragma Assertion_Policy (Check);

with AUnit.Options;
with AUnit.Reporter.Text;
with AUnit.Run;
with AUnit.Test_Caller;
with AUnit.Test_Suites;
with rdrand.test;

procedure Test_Init is

   --  test vector index
   I : constant Positive := 99;

   --  test type mod 64 | 32 | 16
   type rd64 is mod 2**64 with
      Size => 64;

   package Rd_Aggregate is new rdrand.test (rx => rd64, idx => I);
   package Rd_Colloid_F is new AUnit.Test_Caller (Rd_Aggregate.Fixture);

   Suite : constant AUnit.Test_Suites.Access_Test_Suite := AUnit.Test_Suites.New_Suite;

   function Set_Up return AUnit.Test_Suites.Access_Test_Suite;
   function Set_Up return AUnit.Test_Suites.Access_Test_Suite is
   begin
      Suite.Add_Test (Rd_Colloid_F.Create ("Test Collision", Rd_Aggregate.Test_Collision'Access));
      Suite.Add_Test (Rd_Colloid_F.Create ("Test Entropy", Rd_Aggregate.Test_Entropy'Access));
      return Suite;
   end Set_Up;

   procedure Manager is new AUnit.Run.Test_Runner (Set_Up);

   Options  : constant AUnit.Options.AUnit_Options := (True, True, True, null);
   Reporter : AUnit.Reporter.Text.Text_Reporter;

begin

   Reporter.Set_Use_ANSI_Colors (True);
   Manager (Reporter, Options);

end Test_Init;
