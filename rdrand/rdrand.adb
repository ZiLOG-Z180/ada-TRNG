--  Ada interface for TRNG (Cryptographic Co-Processor). Coded by Wojciech Lawren.

--  Copyright (C) 2020, Wojciech Lawren, All rights reserved.

--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
--  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
--  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
--  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
--  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
pragma Ada_2022;
--  RDRAND RDSEED
with System.Machine_Code; use System.Machine_Code;

package body rdrand is

   RC : constant        := 10;
   NL : constant String := ASCII.LF & ASCII.HT;

   function rand return rx is
      r : rx;
   begin
      Asm
        (Template => "movl %1, %%ecx"       & NL &
                     "1:"                   & NL &
                     "rdrand %0"            & NL &
                     "jc 2f"                & NL &
                     "loop 1b"              & NL &
                     "cmovncl %%ecx, %%eax" & NL &
                     "2:",
         Outputs  => (rx'Asm_Output ("=a", r)),
         Inputs   => (Integer'Asm_Input ("n", RC)),
         Clobber  => "rcx, cc",
         Volatile => True);
      return r;
   end rand;

   function seed return sx is
      r : sx;
   begin
      Asm
        (Template => "movl %1, %%ecx"       & NL &
                     "1:"                   & NL &
                     "rdseed %0"            & NL &
                     "jc 2f"                & NL &
                     "loop 1b"              & NL &
                     "cmovncl %%ecx, %%eax" & NL &
                     "2:",
         Outputs  => (sx'Asm_Output ("=a", r)),
         Inputs   => (Integer'Asm_Input ("n", RC)),
         Clobber  => "rcx, cc",
         Volatile => True);
      return r;
   end seed;

end rdrand;
