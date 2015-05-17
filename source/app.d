import std.stdio;
import dexpect;


void main()
{
	Expect e = new Expect(`C:\Windows\System32\cmd.exe`);

}

/+
version(ExpectMain){
	pragma(msg, "This implementation of expect is very naive, be careful using it!");
	import docopt;
	const string doc =
"dexpect
Usage:
    dexpect [-h] <file>
Options:
    -h --help    Show this message
";
	string[string] customVariables;
	int main(string[] args){
		auto arguments = docopt.docopt(doc, args[1..$], true, "dexpect 0.0.1");
		writeln(arguments);
		File expectScript = File(arguments["<file>"].toString, "r");
		Expect expect;
		foreach(ref line; expectScript.byLine){
			line.strip;
			if(line.length==0) continue;
			if(line[0]=='#') continue;
			// TODO: This switch statement is brittle, write a better command handler
			switch(line.startsWith("set", "spawn", "expect", "send", "print")){
				case 1:
					if(!line.canFind("=")) throw new ExpectException("Parsing error");
					auto equalsIdx = line.indexOf("=");
					string name = line[4..equalsIdx].idup;
					string value = line[equalsIdx+1..$].idup;
					if(expect !is null && name=="timeout")
						expect.timeout = value.to!long;
					customVariables[name] = value;
					break;
				case 2:
					string cmd = line[6..$].idup;
					string[] cmdArgs;
					if(cmd.canFind(" ")){
						cmdArgs = cmd[cmd.indexOf(" ")..$].idup.split(" ");
						cmd = cmd[0..cmd.indexOf(" ")];
					}
					expect = new Expect(cmd, cmdArgs);
					if(customVariables.keys.canFind("timeout"))
						expect.timeout = customVariables["timeout"].to!long;
					break;
				case 3:
					assert(expect !is null, "Error, must spawn before expect");
					string toExpect = line[7..$].idup;
					expect.expect(toExpect);
					break;
				case 4:
					assert(expect !is null, "Error, must spawn before sending data");
					expect.sendLine(line[5..$].idup);
					break;
				case 5:
					if(line == "print all")
						expect.readAllAvailable;
					else expect.read;
					writefln("All data:\n%s", expect.data);
					break;
				default: writefln("Parsing error"); return 1;
			}
		}
		return 0;
	}
}+/