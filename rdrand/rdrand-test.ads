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

with Ada.Containers.Ordered_Sets;
with Ada.Containers.Vectors;
with AUnit.Test_Fixtures;

generic
   type rx is mod <>;
   idx : in Positive := 99;
package rdrand.test is

   --  test function
   function randx is new rand (rx);
   --  test function
   function seedx is new seed (rx);

   --  vector
   package VX is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => rx);
   --  set
   package SX is new Ada.Containers.Ordered_Sets (Element_Type => rx);

   --  fixture
   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with record
      M_V1 : VX.Vector;
      M_S1 : SX.Set;
      M_V2 : VX.Vector;
      M_S2 : SX.Set;
   end record with
      Preelaborable_Initialization;

   procedure Set_Up (T : in out Fixture);

   procedure Tear_Down (T : in out Fixture);

   procedure Test_Collision (T : in out Fixture);

   procedure Test_Entropy (T : in out Fixture);

end rdrand.test;
