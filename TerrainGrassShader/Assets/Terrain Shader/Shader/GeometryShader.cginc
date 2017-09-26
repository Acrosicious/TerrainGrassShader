// Geometry Shader -----------------------------------------------------
#define calculateHealthColor(idx1) lerp(_Dry##idx1, _Healthy##idx1, noise);

[maxvertexcount(32)]
void geometry_shader(triangle DS_OUTPUT IN[3], inout TriangleStream<GS_OUTPUT> triStream)
{
	GS_OUTPUT OUT = (GS_OUTPUT) 0;

	bool b = UnityWorldViewFrustumCull(IN[0].position, IN[1].position, IN[2].position, 2.0);
	
	if(IN[0].discardFlag || b){
		return;
	}
	
	// Mean of grass density at this location
	// float sumDensity = IN[0].density + IN[1].density + IN[2].density;
	// float density = sumDensity / 3.0f + 0.01;
	// density = 1.0f / density;

	float4 SD = IN[0].density; // single densities
	// float density = SD.r * _tex1Enabled + SD.g * _tex2Enabled + SD.b * _tex3Enabled + SD.a * _tex4Enabled;

	float noise = IN[0].noise;

	float influence = 1.0 - _NoiseInfluence;
	float d2 = (1.0 - influence) / 2.0;
	noise -= d2;
	noise *= 1.0 / influence;
	noise = clamp(noise, 0.0, 1.0);
	
	float rndNb = rand(IN[2].position);
	int type = 0;

	float density = SD.r * _tex1Enabled;
	if(rndNb < SD.r){
		if(_tex1Enabled)
			type = 1;
	}else if(rndNb <= (density += SD.g)){
		if(_tex2Enabled)
			type = 2;
	}else if(rndNb <= (density += SD.b)){
		if(_tex3Enabled)
			type = 3;
	}else if(_tex4Enabled){
		type = 4;
	}
	if(type == 0) return;//type = 1;

	density = SD.r * _tex1Enabled + SD.g * _tex2Enabled + SD.b * _tex3Enabled + SD.a * _tex4Enabled;

	float4 healthColor = float4(0,0,0,1);
	float WIDTH = 0.0;
	float HEIGHT = 0.0;
	switch(type){
		case 1: 
			healthColor = calculateHealthColor(1);
			WIDTH = _Width1;
			HEIGHT = _Height1;
		break;
		case 2: 
			healthColor = calculateHealthColor(2); 
			WIDTH = _Width2;
			HEIGHT = _Height2;
		break;
		case 3: 
			healthColor = calculateHealthColor(3); 
			WIDTH = _Width3;
			HEIGHT = _Height3;
		break;
		case 4: 
			healthColor = calculateHealthColor(4); 
			WIDTH = _Width4;
			HEIGHT = _Height4;
		break;
	}

	// float4 color = float4(0.0f, density, 0.0f, 1.0f);

	// Center of triangle
	float4 sum = IN[0].position + IN[1].position + IN[2].position;
	float4 center = sum / 3.0f;

	// Distance to Camera
	float cameraDistance = distance(mul(center, unity_ObjectToWorld).xyz, _WorldSpaceCameraPos);

	#if defined(GrassHelper_ShadowPass)
		if(cameraDistance > _ShadowBillboardDistance){
			return;
		}
	#endif

	if(cameraDistance > _MaxCameraDistance){
		return;
	}

	float maxLod = 2.0f;
	float lod = 1.0f - cameraDistance / _MaxCameraDistance;

	// Area triangle Herons formula
	float area = triangleArea(IN[0].position, IN[1].position, IN[2].position);

	// number of Grass blades
	float blades = area * (_Density / _DensityWeight) * density;

	if(blades < 1.0f){
		blades = rand(IN[1].position) < blades ? 1.0f : 0.0f;
	}
	else{
		blades = round(blades);
	}

	if(area >= _Debug100){
		IN[0].color = float4(1.0, 0, 0, 1);
	}

	float corners = _lessBB ? 1.0 : 2.0;
	float maxCorners = 3.0;

	if(_moreBB)
		corners = 3.0f;

	// Transition between 3 and 2 billboards
	float cutout = 0.0f;
	float delta = cameraDistance - _TriBillboardDistance;
	if(delta < _transitionDistance && delta > 0.0f){
		cutout = delta / _transitionDistance;
	}								

	if(cameraDistance > _TriBillboardDistance + _transitionDistance)
		corners = _lessBB ? 1.0 : 2.0;


	float3 nextRandom = rand3(IN[0].position);

	for(int i = 0; i < blades; i++){

		float4 pos = getRandomPointInTriangle(IN[0].position, IN[1].position, IN[2].position, nextRandom.xy);

		float a = rand(pos) * 3.141f;
		float r = 3.14159f * 2.0f / maxCorners;						
		for(int j = 0; j < corners; j++){

			// float h = rand(pos) * 0.5f + 0.5f;
			GrassBillboard bb = generateGrassBillboard(pos, density, float2(WIDTH, HEIGHT / 2.0f + _Height1 * noise), a);

			[unroll]
			for(int i = 0; i < 4; i++){
				bb.vertices[i].color = healthColor;
				bb.vertices[i].cutout = cutout;
				bb.vertices[i].id = j;
				bb.vertices[i].type = type;
				triStream.Append(bb.vertices[i]);
			}

			triStream.RestartStrip();

			a += r;

		}		

		// get a new Random
		nextRandom = rand3(nextRandom * 100);
	}

	// Terrain triangles
	// float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);

	// GS_OUTPUT gsOUT = (GS_OUTPUT) 0;

	// gsOUT.pos = mul(vp, IN[0].position);
	// gsOUT.tex0 = float2(0.0f, 0.0f);
	// gsOUT.ground = 1.0f;
	// // gsOUT.color = IN[0].color;
	// gsOUT.color = color;
	// triStream.Append(gsOUT);

	// gsOUT.pos = mul(vp, IN[1].position);
	// gsOUT.tex0 = float2(1.0f, 0.0f);
	// gsOUT.ground = 1.0f;
	// // gsOUT.color = IN[1].color;
	// gsOUT.color = color;
	// triStream.Append(gsOUT);

	// gsOUT.pos = mul(vp, IN[2].position);
	// gsOUT.tex0 = float2(0.0f, 1.0f);
	// gsOUT.ground = 1.0f;
	// // gsOUT.color = IN[2].color;
	// gsOUT.color = color;
	// triStream.Append(gsOUT);

}