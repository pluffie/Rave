import std.stdio;
import lexer.lexer;
import std.conv : to;
import compiler;
import core.stdc.stdlib : exit;
import parser.parser;
import llvm;

string[] files;
string outfile;
string outtype;

version(Win64) {
	outtype = "win64";
}

version(Win32) {
	outtype = "win32";
}

version(linux) {
	version(X86_64) {
		outtype = "linux-x86_64";
	}
	version(X86) {
		outtype = "linux-i686";
	}
}

struct CompOpts {
	bool noPrelude = false;
	bool debugMode = false;
	bool emit_llvm = false;
	string linkparams = "";
	bool onlyObject = false;
	bool noEntry = false;
	bool noStd = false;
	bool printAll = false;
}

CompOpts analyzeArgs(string[] args) {
	int idx = 0;
	CompOpts opts;
	while(idx<args.length) {
			if(args[idx] == "-o") {
				idx += 1;
				outfile = args[idx];
				idx += 1;
			}
			else if(args[idx] == "-noprelude") {
				opts.noPrelude = true;
				idx += 1;
			}
			else if(args[idx] == "-debug") {
				opts.debugMode = true;
				idx += 1;
			}
			else if(args[idx] == "-type") {
				idx += 1;
				outtype = args[idx];
				idx += 1;
			}
			else if(args[idx] == "-print-all") {
				idx += 1;
				opts.printAll = true;
			}
			else if(args[idx] == "-emit-llvm") {
				idx += 1;
				opts.emit_llvm = true;
			}
			else if(args[idx] == "-l") {
				idx += 1;
				opts.linkparams ~= "-l"~args[idx];
				idx += 1;
			}
			else if(args[idx] == "-c") {
				idx += 1;
				opts.onlyObject = true;
			}
			else if(args[idx] == "-noentry") {
				idx += 1;
				opts.noEntry = true;
			}
			else if(args[idx] == "-nostd") {
				idx += 1;
				opts.noStd = true;
			}
			else {
				files ~= args[idx];
				idx += 1;
			}
	}
	return opts;
}

void main(string[] args)
{
	if(args.length==1) {
		writeln("Error: files to compile didn't found!");
		exit(1);
	}
	CompOpts o = analyzeArgs(args[1..$]);
	Compiler compiler = new Compiler(outfile,outtype,o);
	compiler.compileAll();
}
