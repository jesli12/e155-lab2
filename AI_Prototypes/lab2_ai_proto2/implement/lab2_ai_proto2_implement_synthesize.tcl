if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2026.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) "1"
set para(prj_dir) "C:/Users/jesli/Documents/GitHub/e155-lab2/AI_Prototypes/lab2_ai_proto2"
if {![file exists {C:/Users/jesli/Documents/GitHub/e155-lab2/AI_Prototypes/lab2_ai_proto2/implement}]} {
  file mkdir {C:/Users/jesli/Documents/GitHub/e155-lab2/AI_Prototypes/lab2_ai_proto2/implement}
}
cd {C:/Users/jesli/Documents/GitHub/e155-lab2/AI_Prototypes/lab2_ai_proto2/implement}
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- lab2_ai_proto2_implement_cpe.ldc
::radiant::runengine::run_engine_newmsg cpe -syn lse -f "lab2_ai_proto2_implement.cprj" -a "iCE40UP"  -o lab2_ai_proto2_implement_cpe.ldc
# synthesize top design
file delete -force -- lab2_ai_proto2_implement.vm lab2_ai_proto2_implement.ldc
::radiant::runengine::run_engine_newmsg synthesis -f "C:/Users/jesli/Documents/GitHub/e155-lab2/AI_Prototypes/lab2_ai_proto2/implement/lab2_ai_proto2_implement_lattice.synproj" -logfile "lab2_ai_proto2_implement_lattice.srp"
::radiant::runengine::run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o lab2_ai_proto2_implement_syn.udb lab2_ai_proto2_implement.vm] [list lab2_ai_proto2_implement.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
