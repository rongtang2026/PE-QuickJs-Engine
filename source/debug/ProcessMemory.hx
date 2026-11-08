package debug;

class ProcessMemory
{
	public static var instance:ProcessMemory = null;
	var androidMB:Int = 0;
	var dataMB:Dynamic = null;
	var residentMB:Int = 0;
	var statmPagesMB:Int = 0;
	var totalMB:Dynamic = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public function readProcValue(key:String):Null<Float>
	{
		#if (android || linux)
		try
		{
			for (line in sys.io.File.getContent('/proc/meminfo').split("\n"))
				if (line.indexOf(key) == 0)
					return Std.parseFloat(line.substr(key.length).replace('kB', '').trim()) / 1024;
		}
		catch (e:Dynamic) {}
		#end
		return null;
	}

	public function readTotalMB():Float
	{
		var v:Null<Float> = readProcValue('MemTotal:');
		return v == null ? -1 : v;
	}

	public function readStatmMB():Float
	{
		#if (android || linux)
		try
		{
			var statm:Array<String> = sys.io.File.getContent('/proc/self/statm').split(' ');
			statmPagesMB = Std.parseInt(statm[1]);
			if (statmPagesMB > 0) return statmPagesMB * 4 / 1024;
		}
		catch (e:Dynamic) {}
		#end
		return -1;
	}

	public function readStatmSharedMB():Float
	{
		#if (android || linux)
		try
		{
			var statm:Array<String> = sys.io.File.getContent('/proc/self/statm').split(' ');
			var pages:Null<Int> = Std.parseInt(statm[2]);
			if (pages != null && pages > 0) return pages * 4 / 1024;
		}
		catch (e:Dynamic) {}
		#end
		return -1;
	}
}
