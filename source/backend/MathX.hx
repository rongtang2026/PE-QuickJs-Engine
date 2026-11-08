
package backend;

class MathX
{
	public static function selfTest():Bool
	{
		var a:Array<Float> = [1, 2, 3];
		var b:Array<Float> = [4, 5, 6];
		return Math.abs(v3dot(a, b) - 32) < 0.0001 && Math.abs(v3len([3, 4, 0]) - 5) < 0.0001;
	}

	public static function v3add(a:Array<Float>, b:Array<Float>):Array<Float> return [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
	public static function v3sub(a:Array<Float>, b:Array<Float>):Array<Float> return [a[0]-b[0], a[1]-b[1], a[2]-b[2]];
	public static function v3scale(a:Array<Float>, s:Float):Array<Float> return [a[0]*s, a[1]*s, a[2]*s];
	public static function v3cross(a:Array<Float>, b:Array<Float>):Array<Float>
		return [a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]];
	public static function v3lerp(a:Array<Float>, b:Array<Float>, t:Float):Array<Float>
		return [a[0]+(b[0]-a[0])*t, a[1]+(b[1]-a[1])*t, a[2]+(b[2]-a[2])*t];
	public static function v3dot(a:Array<Float>, b:Array<Float>):Float return a[0]*b[0]+a[1]*b[1]+a[2]*b[2];
	public static function v3len(a:Array<Float>):Float return Math.sqrt(v3dot(a, a));
	public static function v3norm(a:Array<Float>):Array<Float>
	{
		var l:Float = v3len(a);
		return l > 0 ? v3scale(a, 1 / l) : [0, 0, 0];
	}

	public static function mat4New():Array<Float> return mat4Identity();
	public static function mat4Free(m:Array<Float>):Void m = null;
	public static function mat4Copy(m:Array<Float>):Array<Float> return m.copy();
	public static function mat4Get(m:Array<Float>, r:Int, c:Int):Float return m[r * 4 + c];
	public static function mat4Identity():Array<Float> return [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1];
	public static function mat4Set(m:Array<Float>, r:Int, c:Int, v:Float):Void m[r * 4 + c] = v;
	public static function mat4Mul(a:Array<Float>, b:Array<Float>):Array<Float>
	{
		var out:Array<Float> = [for (i in 0...16) 0];
		for (r in 0...4) for (c in 0...4)
		{
			var s:Float = 0;
			for (k in 0...4) s += a[r*4+k] * b[k*4+c];
			out[r*4+c] = s;
		}
		return out;
	}
	public static function mat4Translate(m:Array<Float>, x:Float, y:Float, z:Float):Array<Float>
	{
		var t:Array<Float> = mat4Identity(); t[3] = x; t[7] = y; t[11] = z;
		return mat4Mul(m, t);
	}
	public static function mat4Scale(m:Array<Float>, x:Float, y:Float, z:Float):Array<Float>
	{
		var t:Array<Float> = mat4Identity(); t[0] = x; t[5] = y; t[10] = z;
		return mat4Mul(m, t);
	}
	public static function mat4Rotate(m:Array<Float>, angle:Float, x:Float, y:Float, z:Float):Array<Float>
	{
		var c:Float = Math.cos(angle), s:Float = Math.sin(angle);
		var t:Array<Float> = mat4Identity();
		t[0] = x*x*(1-c)+c; t[1] = x*y*(1-c)-z*s; t[2] = x*z*(1-c)+y*s;
		t[4] = y*x*(1-c)+z*s; t[5] = y*y*(1-c)+c; t[6] = y*z*(1-c)-x*s;
		t[8] = x*z*(1-c)-y*s; t[9] = y*z*(1-c)+x*s; t[10] = z*z*(1-c)+c;
		return mat4Mul(m, t);
	}
	public static function mat4Perspective(fovy:Float, aspect:Float, near:Float, far:Float):Array<Float>
	{
		var f:Float = 1 / Math.tan(fovy / 2);
		return [f/aspect,0,0,0, 0,f,0,0, 0,0,(far+near)/(near-far),-1, 0,0,(2*far*near)/(near-far),0];
	}
	public static function mat4Ortho(l:Float, r:Float, b:Float, t:Float, n:Float, f:Float):Array<Float>
		return [2/(r-l),0,0,0, 0,2/(t-b),0,0, 0,0,-2/(f-n),0, -(r+l)/(r-l),-(t+b)/(t-b),-(f+n)/(f-n),1];
	public static function mat4LookAt(eye:Array<Float>, center:Array<Float>, up:Array<Float>):Array<Float>
	{
		var z:Array<Float> = v3norm(v3sub(eye, center));
		var x:Array<Float> = v3norm(v3cross(up, z));
		var y:Array<Float> = v3cross(z, x);
		return [x[0],y[0],z[0],0, x[1],y[1],z[1],0, x[2],y[2],z[2],0,
			-v3dot(x,eye),-v3dot(y,eye),-v3dot(z,eye),1];
	}
	public static function mat4MulV3(m:Array<Float>, v:Array<Float>):Array<Float>
		return [m[0]*v[0]+m[1]*v[1]+m[2]*v[2]+m[3],
			m[4]*v[0]+m[5]*v[1]+m[6]*v[2]+m[7],
			m[8]*v[0]+m[9]*v[1]+m[10]*v[2]+m[11]];

	public static function fbm2(x:Float, y:Float, octaves:Int = 4):Float
	{
		var v:Float = 0, amp:Float = 0.5, freq:Float = 1;
		for (i in 0...octaves)
		{
			v += amp * (Math.sin(x * freq) * Math.cos(y * freq));
			freq *= 2; amp *= 0.5;
		}
		return v;
	}

	public static function setCallback(name:String, cb:Dynamic):Void {}
	public static function callbackOf(name:String):Dynamic return null;
	public static function add(v:Dynamic):Void {}
	public static function remove(v:Dynamic):Void {}
	public static function clear():Void {}
	public static function hit():Bool return false;
	public static function update():Void {}

	public function perlin2(x:Float, y:Float):Float
	{
		var xi:Int = Math.floor(x) & 255, yi:Int = Math.floor(y) & 255;
		var xf:Float = x - Math.floor(x), yf:Float = y - Math.floor(y);
		var u:Float = fadeT(xf), v:Float = fadeT(yf);
		var aa:Int = permI(permI(xi) + yi), ab:Int = permI(permI(xi) + yi + 1);
		var ba:Int = permI(permI(xi + 1) + yi), bb:Int = permI(permI(xi + 1) + yi + 1);
		var x1:Float = lerpN(grad2(aa, xf, yf), grad2(ba, xf - 1, yf), u);
		var x2:Float = lerpN(grad2(ab, xf, yf - 1), grad2(bb, xf - 1, yf - 1), u);
		return lerpN(x1, x2, v);
	}

	public function perlin3(x:Float, y:Float, z:Float):Float
	{
		// three offset 2D slices approximate 3D without a full gradient table
		return (perlin2(x + z * 0.7, y - z * 0.3) + perlin2(y + z * 0.5, x - z * 0.9)) * 0.5;
	}
}
