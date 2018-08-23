#! /bin/sh -
#	@(#)makesyscalls.sh	8.1 (Berkeley) 6/10/93
# $FreeBSD$

set -e

# name of compat options:
compat=COMPAT_43
compat4=COMPAT_FREEBSD4
compat6=COMPAT_FREEBSD6
compat7=COMPAT_FREEBSD7
compat10=COMPAT_FREEBSD10
compat11=COMPAT_FREEBSD11

# output files:
sysargmap="/dev/null"
sysargmap_h="_SYS_SYSARGMAP_H_"
sysnames="syscalls.c"
sysstubs="/dev/null"
sysproto="../sys/sysproto.h"
sysproto_h=_SYS_SYSPROTO_H_
syshdr="../sys/syscall.h"
sysmk="../sys/syscall.mk"
syssw="init_sysent.c"
syscallprefix="SYS_"
switchname="sysent"
namesname="syscallnames"
ptrmaskname="sysargmask"
systrace="systrace_args.c"
ptr_intptr_t_cast="intptr_t"
ptr_qualified="*"

# tmp files:
sysaue="sysent.aue.$$"
sysdcl="sysent.dcl.$$"
syscompat="sysent.compat.$$"
syscompatdcl="sysent.compatdcl.$$"
syscompat4="sysent.compat4.$$"
syscompat4dcl="sysent.compat4dcl.$$"
syscompat6="sysent.compat6.$$"
syscompat6dcl="sysent.compat6dcl.$$"
syscompat7="sysent.compat7.$$"
syscompat7dcl="sysent.compat7dcl.$$"
syscompat10="sysent.compat10.$$"
syscompat10dcl="sysent.compat10dcl.$$"
syscompat11="sysent.compat11.$$"
syscompat11dcl="sysent.compat11dcl.$$"
sysent="sysent.switch.$$"
sysinc="sysinc.switch.$$"
sysarg="sysarg.switch.$$"
sysprotoend="sysprotoend.$$"
systracetmp="systrace.$$"
systraceret="systraceret.$$"
sysstubfwd="sysstubfwd.$$"
sysstubstubs="sysstubstubs.$$"

# default input files:
capabilities_conf="capabilities.conf"

trap "rm $sysaue $sysdcl $syscompat $syscompatdcl $syscompat4 $syscompat4dcl $syscompat6 $syscompat6dcl $syscompat7 $syscompat7dcl $syscompat10 $syscompat10dcl $syscompat11 $syscompat11dcl $sysent $sysinc $sysarg $sysprotoend $systracetmp $systraceret $sysstubfwd $sysstubstubs" 0

touch $sysaue $sysdcl $syscompat $syscompatdcl $syscompat4 $syscompat4dcl $syscompat6 $syscompat6dcl $syscompat7 $syscompat7dcl $syscompat10 $syscompat10dcl $syscompat11 $syscompat11dcl $sysent $sysinc $sysarg $sysprotoend $systracetmp $systraceret $sysstubfwd $sysstubstubs

case $# in
    0)	echo "usage: $0 input-file <config-file>" 1>&2
	exit 1
	;;
esac

if [ -n "$2" ]; then
	. $2
fi

if [ -r $capabilities_conf ]; then
	capenabled=`cat $capabilities_conf | grep -v "^#" | grep -v "^$"`
	capenabled=`echo $capenabled | sed 's/ /,/g'`
else
	capenabled=""
fi

sed -e '
:join
	/\\$/{a\

	N
	s/\\\n//
	b join
	}
2,${
	/^#/!s/\([{}()*,]\)/ \1 /g
}
' < $1 | awk "
	BEGIN {
		sysaue = \"$sysaue\"
		sysdcl = \"$sysdcl\"
		sysproto = \"$sysproto\"
		sysprotoend = \"$sysprotoend\"
		sysproto_h = \"$sysproto_h\"
		syscompat = \"$syscompat\"
		syscompatdcl = \"$syscompatdcl\"
		syscompat4 = \"$syscompat4\"
		syscompat4dcl = \"$syscompat4dcl\"
		syscompat6 = \"$syscompat6\"
		syscompat6dcl = \"$syscompat6dcl\"
		syscompat7 = \"$syscompat7\"
		syscompat7dcl = \"$syscompat7dcl\"
		syscompat10 = \"$syscompat10\"
		syscompat10dcl = \"$syscompat10dcl\"
		syscompat11 = \"$syscompat11\"
		syscompat11dcl = \"$syscompat11dcl\"
		sysent = \"$sysent\"
		syssw = \"$syssw\"
		sysinc = \"$sysinc\"
		sysarg = \"$sysarg\"
		sysargmap = \"$sysargmap\"
		sysargmap_h = \"$sysargmap_h\"
		sysnames = \"$sysnames\"
		syshdr = \"$syshdr\"
		sysmk = \"$sysmk\"
		systrace = \"$systrace\"
		systracetmp = \"$systracetmp\"
		systraceret = \"$systraceret\"
		sysstubs = \"$sysstubs\"
		sysstubfwd = \"$sysstubfwd\"
		sysstubstubs = \"$sysstubstubs\"
		compat = \"$compat\"
		compat4 = \"$compat4\"
		compat6 = \"$compat6\"
		compat7 = \"$compat7\"
		compat10 = \"$compat10\"
		compat11 = \"$compat11\"
		syscallprefix = \"$syscallprefix\"
		switchname = \"$switchname\"
		namesname = \"$namesname\"
		ptrmaskname = \"$ptrmaskname\"
		infile = \"$1\"
		capenabled_string = \"$capenabled\"
		cap_prefix = \"$cap_prefix\"
		ptr_intptr_t_cast = \"$ptr_intptr_t_cast\"
		ptr_qualified = \"$ptr_qualified\"
		"'

		split(capenabled_string, capenabled, ",");

		printf "\n/* The casts are bogus but will do for now. */\n" > sysent
		printf "struct sysent %s[] = {\n",switchname > sysent

		printf "/*\n * System call switch table.\n *\n" > syssw
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > syssw
		printf " * $%s$\n", "FreeBSD" > syssw
		printf " */\n\n" > syssw

		printf "/*\n * System call prototypes.\n *\n" > sysarg
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > sysarg
		printf " * $%s$\n", "FreeBSD" > sysarg
		printf " */\n\n" > sysarg

		printf "/*\n * System call argument map.\n *\n" > sysargmap
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > sysargmap
		printf " * $%s$\n", "FreeBSD" > sysargmap
		printf " */\n\n" > sysargmap

		printf "/*\n * System call stub generation macros.\n *\n" > sysstubs
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > sysstubs
		printf " * $%s$\n", "FreeBSD" > sysstubs
		printf " */\n\n" > sysstubs

		printf "#ifndef %s\n", sysproto_h > sysarg
		printf "#define\t%s\n\n", sysproto_h > sysarg
		printf "#include <sys/signal.h>\n" > sysarg
		printf "#include <sys/acl.h>\n" > sysarg
		printf "#include <sys/cpuset.h>\n" > sysarg
		printf "#include <sys/domainset.h>\n" > sysarg
		printf "#include <sys/_ffcounter.h>\n" > sysarg
		printf "#include <sys/_semaphore.h>\n" > sysarg
		printf "#include <sys/ucontext.h>\n" > sysarg
		printf "#include <sys/wait.h>\n\n" > sysarg
		printf "#include <bsm/audit_kevents.h>\n\n" > sysarg
		printf "struct proc;\n\n" > sysarg
		printf "struct thread;\n\n" > sysarg
		printf "#ifdef CPU_CHERI\n" > sysarg
		printf "#define\tCHERI_PADL_(t)\t(sizeof (t) > sizeof(register_t) ? \\\n\t\t0 : sizeof(register_t))\n" > sysarg
		printf "#define\tCHERI_PADR_(t)\t(sizeof (t) > sizeof(register_t ) ? \\\n\t\t0 : sizeof(__intcap_t) - (CHERI_PADL_(t) + sizeof(register_t)))\n" > sysarg
		printf "#else\n" > sysarg
		printf "#define\tCHERI_PADL_(t)\t0\n" > sysarg
		printf "#define\tCHERI_PADR_(t)\t0\n" > sysarg
		printf "#endif\n\n" > sysarg
		printf "#define\tPAD_(t)\t(sizeof(register_t) <= sizeof(t) ? \\\n" > sysarg
		printf "\t\t0 : sizeof(register_t) - sizeof(t))\n\n" > sysarg
		printf "#if BYTE_ORDER == LITTLE_ENDIAN\n"> sysarg
		printf "#define\tPADL_(t)\t0\n" > sysarg
		printf "#define\tPADR_(t)\tPAD_(t)\n" > sysarg
		printf "#else\n" > sysarg
		printf "#define\tPADL_(t)\t(CHERI_PADL_(t) + PAD_(t))\n" > sysarg
		printf "#define\tPADR_(t)\tCHERI_PADR_(t)\n" > sysarg
		printf "#endif\n\n" > sysarg

		printf "#ifndef %s\n", sysargmap_h > sysargmap
		printf "#define\t%s\n\n", sysargmap_h > sysargmap
		printf "int %s[] = {\n",ptrmaskname > sysargmap

		printf "\n#ifdef %s\n\n", compat > syscompat
		printf "\n#ifdef %s\n\n", compat4 > syscompat4
		printf "\n#ifdef %s\n\n", compat6 > syscompat6
		printf "\n#ifdef %s\n\n", compat7 > syscompat7
		printf "\n#ifdef %s\n\n", compat10 > syscompat10
		printf "\n#ifdef %s\n\n", compat11 > syscompat11

		printf "/*\n * System call names.\n *\n" > sysnames
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > sysnames
		printf " * $%s$\n", "FreeBSD" > sysnames
		printf " */\n\n" > sysnames
		printf "const char *%s[] = {\n", namesname > sysnames

		printf "/*\n * System call numbers.\n *\n" > syshdr
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > syshdr
		printf " * $%s$\n", "FreeBSD" > syshdr
		printf " */\n\n" > syshdr

		printf "# FreeBSD system call object files.\n" > sysmk
		printf "# DO NOT EDIT-- this file is automatically generated.\n" > sysmk
		printf "# $%s$\n", "FreeBSD" > sysmk
		printf "MIASM = " > sysmk

		printf "#include <sys/acl.h>\n" > sysstubs
		printf "#include <sys/cpuset.h>\n" > sysstubs
		printf "#include <sys/_domainset.h>\n" > sysstubs
		printf "#include <sys/_ffcounter.h>\n" > sysstubs
		printf "#include <sys/_semaphore.h>\n" > sysstubs
		printf "#include <sys/socket.h>\n" > sysstubs
		printf "#include <sys/ucontext.h>\n" > sysstubs
		printf "#include <compat/cheriabi/cheriabi_signal.h>\n" > sysstubs

		printf "/*\n * System call argument to DTrace register array converstion.\n *\n" > systrace
		printf " * DO NOT EDIT-- this file is automatically generated.\n" > systrace
		printf " * $%s$\n", "FreeBSD" > systrace
		printf " * This file is part of the DTrace syscall provider.\n */\n\n" > systrace
		printf "static void\nsystrace_args(int sysnum, void *params, uint64_t *uarg, int *n_args)\n{\n" > systrace
		printf "\tint64_t *iarg  = (int64_t *) uarg;\n" > systrace
		printf "\tswitch (sysnum) {\n" > systrace

		printf "static void\nsystrace_entry_setargdesc(int sysnum, int ndx, char *desc, size_t descsz)\n{\n\tconst char *p = NULL;\n" > systracetmp
		printf "\tswitch (sysnum) {\n" > systracetmp

		printf "static void\nsystrace_return_setargdesc(int sysnum, int ndx, char *desc, size_t descsz)\n{\n\tconst char *p = NULL;\n" > systraceret
		printf "\tswitch (sysnum) {\n" > systraceret
	}
	NR == 1 {
		next
	}
	NF == 0 || $1 ~ /^;/ {
		next
	}
	$1 ~ /^#[ 	]*include/ {
		print > sysinc
		next
	}
	$1 ~ /^#[ 	]*if/ {
		print > sysent
		print > sysdcl
		print > sysarg
		print > syscompat
		print > syscompat4
		print > syscompat6
		print > syscompat7
		print > syscompat10
		print > syscompat11
		print > sysnames
		print > sysstubs
		print > systrace
		print > systracetmp
		print > systraceret
		savesyscall = syscall
		next
	}
	$1 ~ /^#[ 	]*else/ {
		print > sysent
		print > sysdcl
		print > sysarg
		print > syscompat
		print > syscompat4
		print > syscompat6
		print > syscompat7
		print > syscompat10
		print > syscompat11
		print > sysnames
		print > sysstubs
		print > systrace
		print > systracetmp
		print > systraceret
		syscall = savesyscall
		next
	}
	$1 ~ /^#/ {
		print > sysent
		print > sysdcl
		print > sysarg
		print > syscompat
		print > syscompat4
		print > syscompat6
		print > syscompat7
		print > syscompat10
		print > syscompat11
		print > sysnames
		print > sysstubs
		print > systrace
		print > systracetmp
		print > systraceret
		next
	}
	# Returns true if the type "name" is the first flag in the type field
	function type(name, flags, n) {
		n = split($3, flags, /\|/)
		return (n > 0 && flags[1] == name)
	}
	# Returns true if the given type is a pointer type
	function isptrtype(type) {
		return (type ~ /\*/ || type ~ /caddr_t/ || type ~ /intcap_t/ ||
		    type ~ /intptr_t/)
	}
	# Returns true if the flag "name" is set in the type field
	function flag(name, flags, i, n) {
		n = split($3, flags, /\|/)
		for (i = 1; i <= n; i++)
			if (flags[i] == name)
				return 1
		return 0
	}
	{
		n = split($1, syscall_range, /-/)
		if (n == 1) {
			syscall_range[2] = syscall_range[1]
		} else if (n == 2) {
			if (!type("UNIMPL")) {
				printf "%s: line %d: range permitted only with UNIMPL\n",
				    infile, NR
				exit 1
			}
		} else {
			printf "%s: line %d: invalid syscall number or range %s\n",
			    infile, NR, $1
			exit 1
		}
	}
	syscall != syscall_range[1] {
		printf "%s: line %d: syscall number out of sync at %d\n",
		    infile, NR, syscall
		printf "line is:\n"
		print
		exit 1
	}
	function align_sysent_comment(column) {
		printf("\t") > sysent
		column = column + 8 - column % 8
		while (column < 56) {
			printf("\t") > sysent
			column = column + 8
		}
	}
	function parserr(was, wanted) {
		printf "%s: line %d: unexpected %s (expected %s)\n",
		    infile, NR, was, wanted
		exit 1
	}
	function parseline() {
		f=4			# toss number, type, audit event
		ret_inc = 0
		argc= 0;
		argssize = "0"
		thr_flag = "SY_THR_STATIC"
		if (flag("NOTSTATIC")) {
			thr_flag = "SY_THR_ABSENT"
		}
		if ($NF != "}") {
			funcalias=$(NF-2)
			argalias=$(NF-1)
			rettype=$NF
			userrettype=$NF
			end=NF-3
		} else {
			funcalias=""
			argalias=""
			rettype="int"
			userrettype=$(f+1)
			if ($(f+2) == "*") {
				userrettype = userrettype "*"
				ret_inc = 1
			}
			end=NF
		}
		if (flag("NODEF")) {
			auditev="AUE_NULL"
			funcname=$(4 + ret_inc)
			argssize = "AS(" $(6 + ret_inc) ")"
			return
		}
		if ($f != "{")
			parserr($f, "{")
		f++
		if ($end != "}")
			parserr($end, "}")
		end--
		if ($end != ";")
			parserr($end, ";")
		end--
		if ($end != ")")
			parserr($end, ")")
		end--

		f += ret_inc
		syscallret=$f
		f++

		funcname=$f

		#
		# We now know the func name, so define a flags field for it.
		# Do this before any other processing as we may return early
		# from it.
		#
		for (cap in capenabled) {
			if (funcname == capenabled[cap] || funcname == cap_prefix capenabled[cap] ) {
				flags = "SYF_CAPENABLED";
				break;
			}
		}

		if (funcalias == "")
			funcalias = funcname
		if (argalias == "") {
			argalias = funcname "_args"
			if (flag("COMPAT"))
				argalias = "o" argalias
			if (flag("COMPAT4"))
				argalias = "freebsd4_" argalias
			if (flag("COMPAT6"))
				argalias = "freebsd6_" argalias
			if (flag("COMPAT7"))
				argalias = "freebsd7_" argalias
			if (flag("COMPAT10"))
				argalias = "freebsd10_" argalias
			if (flag("COMPAT11"))
				argalias = "freebsd11_" argalias
		}
		f++

		if ($f != "(")
			parserr($f, ")")
		f++

		if (f == end) {
			if ($f != "void")
				parserr($f, "argument definition")
			return
		}

		while (f <= end) {
			argc++
			argtype[argc]=""
			oldf=""
			while (f < end && $(f+1) != ",") {
				if (argtype[argc] != "" && oldf != "*")
					argtype[argc] = argtype[argc]" ";
				if (oldf == "struct") {
					arg_structs[$f]
				}
				if (oldf == "union")
					arg_unions[$f]
				argtype[argc] = argtype[argc]$f;
				oldf = $f;
				f++
			}
			if (argtype[argc] == "")
				parserr($f, "argument definition")
			# The parser adds space around parens.
			# Remove it from annotations.
			gsub(/ \( /, "(", argtype[argc]);
			gsub(/ \)/, ")", argtype[argc]);
			# Strip SAL annotations
			gsub(/_In[^ ]*[_)] /, "", argtype[argc]);
			gsub(/_Out[^ ]*[_)] /, "", argtype[argc]);
			gsub(/_Pagerange[^ ]*[_)] /, "", argtype[argc]);
			# Allow pointers to be qualified
			gsub(/\*/, ptr_qualified, argtype[argc]);
			sub(/ $/, "", argtype[argc]);
			argname[argc]=$f;
			f += 2;			# skip name, and any comma
		}
		if (argc != 0)
			argssize = "AS(" argalias ")"
	}
	{	comment = $4
		if (NF < 7)
			for (i = 5; i <= NF; i++)
				comment = comment " " $i
	}

	#
	# The AUE_ audit event identifier.
	#
	{
		auditev = $2;
	}

	#
	# The flags, if any.
	#
	{
		flags = "0";
	}

	type("STD") || type("NODEF") || type("NOARGS") || type("NOPROTO") \
	    || type("NOSTD") {
		parseline()
		printf("\t/* %s */\n\tcase %d: {\n", funcname, syscall) > systrace
		printf("\t/* %s */\n\tcase %d:\n", funcname, syscall) > systracetmp
		printf("\t/* %s */\n\tcase %d:\n", funcname, syscall) > systraceret
		if (argc > 0) {
			printf("\t\tswitch(ndx) {\n") > systracetmp
			printf("\t\tstruct %s *p = params;\n", argalias) > systrace
			for (i = 1; i <= argc; i++) {
				arg = argtype[i]
				sub("__restrict$", "", arg)
				if (index(arg, "*") > 0)
					printf("\t\tcase %d:\n\t\t\tp = \"userland %s\";\n\t\t\tbreak;\n", i - 1, arg) > systracetmp
				else
					printf("\t\tcase %d:\n\t\t\tp = \"%s\";\n\t\t\tbreak;\n", i - 1, arg) > systracetmp
				if (isptrtype(arg))
					printf("\t\tuarg[%d] = (%s) p->%s; /* %s */\n", \
					     i - 1, ptr_intptr_t_cast, \
					     argname[i], arg) > systrace
				else if (arg == "union l_semun")
					printf("\t\tuarg[%d] = p->%s.buf; /* %s */\n", \
					     i - 1, \
					     argname[i], arg) > systrace
				else if (substr(arg, 1, 1) == "u" || arg == "size_t")
					printf("\t\tuarg[%d] = p->%s; /* %s */\n", \
					     i - 1, \
					     argname[i], arg) > systrace
				else
					printf("\t\tiarg[%d] = p->%s; /* %s */\n", \
					     i - 1, \
					     argname[i], arg) > systrace
			}
			printf("\t\tdefault:\n\t\t\tbreak;\n\t\t};\n") > systracetmp

			printf("\t\tif (ndx == 0 || ndx == 1)\n") > systraceret
			printf("\t\t\tp = \"%s\";\n", syscallret) > systraceret
			printf("\t\tbreak;\n") > systraceret
		}
		printf("\t\t*n_args = %d;\n\t\tbreak;\n\t}\n", argc) > systrace
		printf("\t\tbreak;\n") > systracetmp
		if (argc != 0 && !flag("NOARGS") && !flag("NOPROTO") && \
		    !flag("NODEF")) {
			printf("struct %s {\n", argalias) > sysarg
			for (i = 1; i <= argc; i++) {
				a_type = argtype[i]
				gsub (/__restrict/, "", a_type)
				printf("\tchar %s_l_[PADL_(%s)]; " \
				    "%s %s; char %s_r_[PADR_(%s)];\n",
				    argname[i], a_type,
				    a_type, argname[i],
				    argname[i], a_type) > sysarg
			}
			printf("};\n") > sysarg
		}
		else if (!flag("NOARGS") && !flag("NOPROTO") && !flag("NODEF"))
			printf("struct %s {\n\tregister_t dummy;\n};\n",
			    argalias) > sysarg

		if (argc != 0 && !flag("NOARGS") && !flag("NODEF")) {
			printf(" [%s%s] = (0x0", syscallprefix, funcalias) > sysargmap
			for (i = 1; i <= argc; i++)
				if (isptrtype(argtype[i])) {
					printf(" | 0x%x",
					    2 ^ (i - 1)) > sysargmap
				}
			printf "),\n" > sysargmap
		}

		if (!flag("NOSTUB") && !flag("NODEF")) {
			arghasptrs = 0
			for (i = 1; i <= argc; i++) {
				if (isptrtype(argtype[i]) &&
				    argtype[i] ~ /_c[ _]/)
					arghasptrs = 1
			}
			nocheri_funcname = funcname
			sub(/cheriabi_/, "", nocheri_funcname)
			macro_suffix = "";
			if (flag("VARARG"))
				macro_suffix = "_VA"
			else if (arghasptrs != 0)
				macro_suffix = "_ARGHASPTRS"
			printf ("SYS_STUB%s(%s, %s, %s", macro_suffix,
			    syscall == "" ? "0" : syscall, userrettype,
			    nocheri_funcname) > sysstubstubs
			if (flag("VARARG"))
				printf (", %s",
				    argname[argc - 1]) > sysstubstubs

			# _protoargs
			printf (",\n    /* _protoargs */ (") > sysstubstubs
			if (argc == 0) {
				printf "void" > sysstubstubs
			} else {
				for (i = 1; i <= argc; i++) {
					if (i == 1)
						comma = ""
					else
						comma = ", "
					a_type = argtype[i]
					sub(/_c /, "", a_type)
					sub(/_c_/, "_", a_type)
					sub(/__capability/, "", a_type);
					printf("%s%s %s", comma, a_type,
					    argname[i]) > sysstubstubs
				}
			}

			# _vprotoargs
			if (flag("VARARG")) {
				printf ("),\n    /* _vprotoargs */ (") > sysstubstubs
				if (argc == 0) {
					printf "void" > sysstubstubs
				} else {
					for (i = 1; i <= argc; i++) {
						if (i == 1)
							comma = ""
						else
							comma = ", "
						a_type = argtype[i]
						sub(/_c /, "", a_type)
						sub(/_c_/, "_", a_type)
						sub(/__capability/, "", a_type);
						if (i == argc)
							printf(", ...") > sysstubstubs
						else
							printf("%s%s %s", comma,
							    a_type, argname[i]) > sysstubstubs
					}
				}
			}

			# _protoargs_chk
			printf ("),\n    /* _protoargs_chk */ (%s *retp , int * __capability stub_errno",
			    userrettype) > sysstubstubs
			for (i = 1; i <= argc; i++) {
				a_type = argtype[i]
				sub(/_c /, "", a_type)
				sub(/_c_/, "_", a_type)
				sub(/__capability/, "", a_type);
				if (isptrtype(a_type)) {
					if (a_type ~ /intptr_t/) {
						sub(/uintptr_t/, "__uintcap_t",
						    a_type)
						sub(/intptr_t/, "__intcap_t",
						    a_type)
					} else
						gsub(/\*/, "* __capability ",
						    a_type)
				}
				printf(", %s %s", a_type,
				    argname[i]) > sysstubstubs
			}

			# _protoargs_err
			printf ("),\n    /* _protoargs_err */ (__capability int *stub_errno") > sysstubstubs
			for (i = 1; i <= argc; i++) {
				a_type = argtype[i]
				sub(/_c /, "", a_type)
				sub(/_c_/, "_", a_type)
				sub(/__capability/, "", a_type);
				if (isptrtype(a_type)) {
					if (a_type ~ /intptr_t/) {
						sub(/uintptr_t/, "__uintcap_t",
						    a_type)
						sub(/intptr_t/, "__intcap_t",
						    a_type)
					} else
						gsub(/\*/, "* __capability ",
						    a_type)
				}
				printf(", %s %s", a_type,
				    argname[i]) > sysstubstubs
			}

			# _callargs
			printf ("),\n    /* _callargs */ (") > sysstubstubs
			for (i = 1; i <= argc; i++) {
				if (i == 1)
					comma = ""
				else
					comma = ", "
				if (isptrtype(argtype[i]) && !(argtype[i] ~ /caddr_t/) && !(argtype[i] ~ /intptr_t/)) {
					a_type = argtype[i]
					sub(/_c /, "", a_type)
					sub(/_c_/, "_", a_type)
					sub(/__capability/, "", a_type);
					sub(/__restrict/, "", a_type);
					cast = "(__cheri_fromcap " a_type ")"
				} else
					cast = ""
				printf("%s%s%s", comma, cast,
				    argname[i]) > sysstubstubs
			}

			# _callargs_chk
			printf ("),\n    /* _callargs_chk */ (&ret, stub_errno") > sysstubstubs
			for (i = 1; i <= argc; i++) {
				printf(", %s",
				    argname[i]) > sysstubstubs
			}

			# _callargs_err
			printf ("),\n    /* _callargs_err */ (&errno") > sysstubstubs
			for (i = 1; i <= argc; i++) {
				if (isptrtype(argtype[i]) && !(argtype[i] ~ /caddr_t/)) {
					a_type = argtype[i]
					sub(/_c /, "", a_type)
					sub(/_c_/, "_", a_type)
					sub(/__capability/, "", a_type);
					cast = "(" a_type ")"
				} else
					cast = ""
				printf(", %s%s", cast,
				    argname[i]) > sysstubstubs
			}

			# _localcheck
			printf("),\n    /* _localcheck */ {") > sysstubstubs
			for (i = 1; i <= argc; i++) {
				if (isptrtype(argtype[i])) {
					printf("if (!(cheri_getperm(%s) & CHERI_PERM_GLOBAL)) {errno = EPROT; return ((%s)-1);} ",
					    argname[i],
					    userrettype) > sysstubstubs
				}
			}
			print("}") > sysstubstubs

			printf (")\n\n") > sysstubstubs
		}

		if (!flag("NOPROTO") && !flag("NODEF")) {
			if (funcname == "nosys" || funcname == "lkmnosys" ||
			    funcname == "sysarch" ||
			    funcname ~ /^cheriabi/ || funcname ~ /^freebsd/ ||
			    funcname ~ /^linux/ || funcname ~ /^ibcs2/ ||
			    funcname ~ /^xenix/ || funcname ~ /^cloudabi/) {
				printf("%s\t%s(struct thread *, struct %s *)",
				    rettype, funcname, argalias) > sysdcl
			} else {
				printf("%s\tsys_%s(struct thread *, struct %s *)",
				    rettype, funcname, argalias) > sysdcl
			} 
			printf(";\n") > sysdcl
			printf("#define\t%sAUE_%s\t%s\n", syscallprefix,
			    funcalias, auditev) > sysaue
		}
		printf("\t{ %s, (sy_call_t *)", argssize) > sysent
		column = 8 + 2 + length(argssize) + 15
		if (flag("NOSTD")) {
			printf("lkmressys, AUE_NULL, NULL, 0, 0, %s, SY_THR_ABSENT },", flags) > sysent
			column = column + length("lkmressys") + length("AUE_NULL") + 3
		} else {
			if (funcname == "nosys" || funcname == "sysarch" || 
			    funcname == "lkmnosys" ||
			    funcname ~ /^cheriabi/ || funcname ~ /^freebsd/ ||
			    funcname ~ /^linux/ || funcname ~ /^ibcs2/ ||
			    funcname ~ /^xenix/ || funcname ~ /^cloudabi/) {
				printf("%s, %s, NULL, 0, 0, %s, %s },", funcname, auditev, flags, thr_flag) > sysent
				column = column + length(funcname) + length(auditev) + length(flags) + 3 
			} else {
				printf("sys_%s, %s, NULL, 0, 0, %s, %s },", funcname, auditev, flags, thr_flag) > sysent
				column = column + length(funcname) + length(auditev) + length(flags) + 3 + 4
			} 
		} 
		align_sysent_comment(column)
		printf("/* %d = %s */\n", syscall, funcalias) > sysent
		printf("\t\"%s\",\t\t\t/* %d = %s */\n",
		    funcalias, syscall, funcalias) > sysnames
		if (!flag("NODEF")) {
			printf("#define\t%s%s\t%d\n", syscallprefix,
		    	    funcalias, syscall) > syshdr
			printf(" \\\n\t%s.o", funcalias) > sysmk
		}
		syscall++
		next
	}
	type("COMPAT") || type("COMPAT4") || type("COMPAT6") || \
	    type("COMPAT7") || type("COMPAT10") || type("COMPAT11") {
		if (flag("COMPAT")) {
			ncompat++
			out = syscompat
			outdcl = syscompatdcl
			wrap = "compat"
			prefix = "o"
			descr = "old"
		} else if (flag("COMPAT4")) {
			ncompat4++
			out = syscompat4
			outdcl = syscompat4dcl
			wrap = "compat4"
			prefix = "freebsd4_"
			descr = "freebsd4"
		} else if (flag("COMPAT6")) {
			ncompat6++
			out = syscompat6
			outdcl = syscompat6dcl
			wrap = "compat6"
			prefix = "freebsd6_"
			descr = "freebsd6"
		} else if (flag("COMPAT7")) {
			ncompat7++
			out = syscompat7
			outdcl = syscompat7dcl
			wrap = "compat7"
			prefix = "freebsd7_"
			descr = "freebsd7"
		} else if (flag("COMPAT10")) {
			ncompat10++
			out = syscompat10
			outdcl = syscompat10dcl
			wrap = "compat10"
			prefix = "freebsd10_"
			descr = "freebsd10"
		} else if (flag("COMPAT11")) {
			ncompat11++
			out = syscompat11
			outdcl = syscompat11dcl
			wrap = "compat11"
			prefix = "freebsd11_"
			descr = "freebsd11"
		}
		parseline()
		if (argc != 0 && !flag("NOARGS") && !flag("NOPROTO") && \
		    !flag("NODEF")) {
			printf("struct %s {\n", argalias) > out
			for (i = 1; i <= argc; i++)
				printf("\tchar %s_l_[PADL_(%s)]; %s %s; " \
				    "char %s_r_[PADR_(%s)];\n",
				    argname[i], argtype[i],
				    argtype[i], argname[i],
				    argname[i], argtype[i]) > out
			printf("};\n") > out
		}
		else if (!flag("NOARGS") && !flag("NOPROTO") && !flag("NODEF"))
			printf("struct %s {\n\tregister_t dummy;\n};\n",
			    argalias) > sysarg
		if (!flag("NOPROTO") && !flag("NODEF")) {
			printf("%s\t%s%s(struct thread *, struct %s *);\n",
			    rettype, prefix, funcname, argalias) > outdcl
			printf("#define\t%sAUE_%s%s\t%s\n", syscallprefix,
			    prefix, funcname, auditev) > sysaue
		}
		if (flag("NOSTD")) {
			printf("\t{ %s, (sy_call_t *)%s, %s, NULL, 0, 0, 0, SY_THR_ABSENT },",
			    "0", "lkmressys", "AUE_NULL") > sysent
			align_sysent_comment(8 + 2 + length("0") + 15 + \
			    length("lkmressys") + length("AUE_NULL") + 3)
		} else {
			printf("\t{ %s(%s,%s), %s, NULL, 0, 0, %s, %s },",
			    wrap, argssize, funcname, auditev, flags, thr_flag) > sysent
			align_sysent_comment(8 + 9 + length(argssize) + 1 + \
			    length(funcname) + length(auditev) + \
			    length(flags) + 4)
		}
		printf("/* %d = %s %s */\n", syscall, descr, funcalias) > sysent
		printf("\t\"%s.%s\",\t\t/* %d = %s %s */\n",
		    wrap, funcalias, syscall, descr, funcalias) > sysnames
		# Do not provide freebsdN_* symbols in libc for < FreeBSD 7
		if (flag("COMPAT") || flag("COMPAT4") || flag("COMPAT6")) {
			printf("\t\t\t\t/* %d is %s %s */\n",
			    syscall, descr, funcalias) > syshdr
		} else if (!flag("NODEF")) {
			printf("#define\t%s%s%s\t%d\n", syscallprefix,
			    prefix, funcalias, syscall) > syshdr
			printf(" \\\n\t%s%s.o", prefix, funcalias) > sysmk
		}
		syscall++
		next
	}
	type("OBSOL") {
		printf("\t{ 0, (sy_call_t *)nosys, AUE_NULL, NULL, 0, 0, 0, SY_THR_ABSENT },") > sysent
		align_sysent_comment(34)
		printf("/* %d = obsolete %s */\n", syscall, comment) > sysent
		printf("\t\"obs_%s\",\t\t\t/* %d = obsolete %s */\n",
		    $4, syscall, comment) > sysnames
		printf("\t\t\t\t/* %d is obsolete %s */\n",
		    syscall, comment) > syshdr
		syscall++
		next
	}
	type("UNIMPL") {
		while (syscall <= syscall_range[2]) {
			printf("\t{ 0, (sy_call_t *)nosys, AUE_NULL, NULL, 0, 0, 0, SY_THR_ABSENT },\t\t\t/* %d = %s */\n",
			    syscall, comment) > sysent
			printf("\t\"#%d\",\t\t\t/* %d = %s */\n",
			    syscall, syscall, comment) > sysnames
			syscall++
		}
		next
	}
	{
		printf "%s: line %d: unrecognized keyword %s\n", infile, NR, $3
		exit 1
	}
	END {
		printf "\n#define AS(name) (sizeof(struct name) / sizeof(syscallarg_t))\n" > sysinc

		if (ncompat != 0 || ncompat4 != 0 || ncompat6 != 0 || ncompat7 != 0 || ncompat10 != 0 || ncompat11 != 0)
			printf "#include \"opt_compat.h\"\n\n" > syssw

		if (ncompat != 0) {
			printf "\n#ifdef %s\n", compat > sysinc
			printf "#define compat(n, name) n, (sy_call_t *)__CONCAT(o,name)\n" > sysinc
			printf "#else\n" > sysinc
			printf "#define compat(n, name) 0, (sy_call_t *)nosys\n" > sysinc
			printf "#endif\n" > sysinc
		}

		if (ncompat4 != 0) {
			printf "\n#ifdef %s\n", compat4 > sysinc
			printf "#define compat4(n, name) n, (sy_call_t *)__CONCAT(freebsd4_,name)\n" > sysinc
			printf "#else\n" > sysinc
			printf "#define compat4(n, name) 0, (sy_call_t *)nosys\n" > sysinc
			printf "#endif\n" > sysinc
		}

		if (ncompat6 != 0) {
			printf "\n#ifdef %s\n", compat6 > sysinc
			printf "#define compat6(n, name) n, (sy_call_t *)__CONCAT(freebsd6_,name)\n" > sysinc
			printf "#else\n" > sysinc
			printf "#define compat6(n, name) 0, (sy_call_t *)nosys\n" > sysinc
			printf "#endif\n" > sysinc
		}

		if (ncompat7 != 0) {
			printf "\n#ifdef %s\n", compat7 > sysinc
			printf "#define compat7(n, name) n, (sy_call_t *)__CONCAT(freebsd7_,name)\n" > sysinc
			printf "#else\n" > sysinc
			printf "#define compat7(n, name) 0, (sy_call_t *)nosys\n" > sysinc
			printf "#endif\n" > sysinc
		}
		if (ncompat10 != 0) {
			printf "\n#ifdef %s\n", compat10 > sysinc
			printf "#define compat10(n, name) n, (sy_call_t *)__CONCAT(freebsd10_,name)\n" > sysinc
			printf "#else\n" > sysinc
			printf "#define compat10(n, name) 0, (sy_call_t *)nosys\n" > sysinc
			printf "#endif\n" > sysinc
		}
		if (ncompat11 != 0) {
			printf "\n#ifdef %s\n", compat11 > sysinc
			printf "#define compat11(n, name) n, (sy_call_t *)__CONCAT(freebsd11_,name)\n" > sysinc
			printf "#else\n" > sysinc
			printf "#define compat11(n, name) 0, (sy_call_t *)nosys\n" > sysinc
			printf "#endif\n" > sysinc
		}

		printf("\n#endif /* %s */\n\n", compat) > syscompatdcl
		printf("\n#endif /* %s */\n\n", compat4) > syscompat4dcl
		printf("\n#endif /* %s */\n\n", compat6) > syscompat6dcl
		printf("\n#endif /* %s */\n\n", compat7) > syscompat7dcl
		printf("\n#endif /* %s */\n\n", compat10) > syscompat10dcl
		printf("\n#endif /* %s */\n\n", compat11) > syscompat11dcl

		printf("\n#undef PAD_\n") > sysprotoend
		printf("#undef PADL_\n") > sysprotoend
		printf("#undef PADR_\n") > sysprotoend
		printf("\n#endif /* !%s */\n", sysproto_h) > sysprotoend

		printf("\n") > sysmk

		printf("};\n\n") > sysargmap
		printf("#endif /* !%s */\n", sysargmap_h) > sysargmap

		printf("};\n") > sysent
		printf("};\n") > sysnames
		printf("#define\t%sMAXSYSCALL\t%d\n", syscallprefix, syscall) \
		    > syshdr
		printf "\tdefault:\n\t\t*n_args = 0;\n\t\tbreak;\n\t};\n}\n" > systrace
		printf "\tdefault:\n\t\tbreak;\n\t};\n\tif (p != NULL)\n\t\tstrlcpy(desc, p, descsz);\n}\n" > systracetmp
		printf "\tdefault:\n\t\tbreak;\n\t};\n\tif (p != NULL)\n\t\tstrlcpy(desc, p, descsz);\n}\n" > systraceret

		for (struct in arg_structs) {
			sub(/_c$/, "", struct)
			printf("struct %s;\n", struct) > sysstubfwd
		}
		for (union in arg_unions) {
			sub(/_c$/, "", union)
			printf("union %s;\n", union) > sysstubfwd
		}
	} '

cat $sysinc $sysent >> $syssw
cat $sysarg $sysdcl \
	$syscompat $syscompatdcl \
	$syscompat4 $syscompat4dcl \
	$syscompat6 $syscompat6dcl \
	$syscompat7 $syscompat7dcl \
	$syscompat10 $syscompat10dcl \
	$syscompat11 $syscompat11dcl \
	$sysaue $sysprotoend > $sysproto
cat $systracetmp >> $systrace
cat $systraceret >> $systrace
sort $sysstubfwd >> $sysstubs
cat $sysstubstubs >> $sysstubs
