// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Vertex Shader ------------------------------------------------
VS_OUTPUT vertex_shader(VS_INPUT IN)
{
	VS_OUTPUT OUT = (VS_OUTPUT) 0;

	OUT.tc_Control = IN.texcoord;
	//textureMap = tex2D(_Control, OUT.tc_Control);
	//textureMap = _Control.SampleLevel(OUT.tc_Control, 1.0, 0);
	float2 tc_Control = TRANSFORM_TEX(IN.texcoord, _Control);


	float b = tex2Dlod(_Control, float4(tc_Control, 0, 0)).r;
	OUT.density = b;
	OUT.color = float4(0.0f, b, 0.0f, 1.0f);
	// TEST
	//OUT.color = textureMap.rgba;

	OUT.position = mul(unity_ObjectToWorld, IN.position);
	// OUT.position = IN.position; // == POSITION					

	return OUT;
}

// Tesselation 
// HullConstant
HS_CONSTANT_OUTPUT constant_hull_shader(InputPatch<VS_OUTPUT, 3> patch){
	HS_CONSTANT_OUTPUT OUT = (HS_CONSTANT_OUTPUT) 0;

	float smallest = 2.0f * (1.0 - _Tess);// REDUCE FOR BLADES
	float maxTess = 1.0f;
	half dens = 0.0;

	// float cameraDistance = distance(patch[0].position, _WorldSpaceCameraPos);
	// float4 tt = UnityEdgeLengthBasedTessCull(patch[0].position, patch[1].position, patch[2].position, 2.0, 2.0);

	// OUT.EdgeFactors[0] = tt.x;
	// OUT.EdgeFactors[1] = tt.y;
	// OUT.EdgeFactors[2] = tt.z;
	// OUT.InsideFactor = tt.w;
	// return OUT;

	bool b = false;

	#if defined(GrassHelper_ShadowPass)
		#if !defined(SHADOW_ACTIVE)
			OUT.EdgeFactors[0] = 0.0f;
			OUT.EdgeFactors[1] = 0.0f;
			OUT.EdgeFactors[2] = 0.0f;
			OUT.InsideFactor = 0.0f;
			return OUT;
		#endif
		// Distance to Camera
		float cameraDistance = distance(patch[0].position, _WorldSpaceCameraPos);
		cameraDistance = min(distance(patch[1].position, _WorldSpaceCameraPos), cameraDistance);
		cameraDistance = min(distance(patch[2].position, _WorldSpaceCameraPos), cameraDistance);
		if(cameraDistance / 2.0 > _ShadowBillboardDistance){
			b = true;
		}
	#endif

	b = b || UnityWorldViewFrustumCull(patch[0].position, patch[1].position, patch[2].position, 2.0); // P1, P2, P3, epsilon
	// Cull patch if not visible
	if(b){
		OUT.EdgeFactors[0] = 0.0f;
		OUT.EdgeFactors[1] = 0.0f;
		OUT.EdgeFactors[2] = 0.0f;
		OUT.InsideFactor = 0.0f;
		return OUT;
	}

	[unroll]
	for(uint k = 0; k < 3; k++){
		float d = distance(patch[k].position, patch[(k+1)%3].position);
		float n = d/smallest;
		dens += patch[k].density;
		// if(b) n = 0.0;
		// if(cameraDistance > _Debug100) n=_Debug2 * 10.0;
		maxTess = max(maxTess, n);
		OUT.EdgeFactors[(k+2)%3] = n;
	}

	// float4 tt = UnityEdgeLengthBasedTessCull(patch[0].position, patch[1].position, patch[2].position, 2.0, 2.0);
	// OUT.EdgeFactors[0] = tt.x;
	// OUT.EdgeFactors[1] = tt.y;
	// OUT.EdgeFactors[2] = tt.z;
	// OUT.InsideFactor = tt.w;
	// return OUT;

	if(dens == 0.0){
		OUT.EdgeFactors[0] = 0.0f;
		OUT.EdgeFactors[1] = 0.0f;
		OUT.EdgeFactors[2] = 0.0f;
		maxTess = 0.0f;
	}

	// float tess = _Tess;

	OUT.InsideFactor = maxTess;

	return OUT;
}

// HullShader
[domain("tri")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(3)]
[patchconstantfunc("constant_hull_shader")]
HS_OUTPUT hull_shader(InputPatch<VS_OUTPUT, 3> patch, uint controlPointID : SV_OutputControlPointID){
	HS_OUTPUT OUT = (HS_OUTPUT) 0;

	OUT.position = patch[controlPointID].position;
	OUT.density = patch[controlPointID].density;
	OUT.color = patch[controlPointID].color;
	OUT.tc_Control = patch[controlPointID].tc_Control;

	return OUT;
}


// Domain Shader
[domain("tri")]
DS_OUTPUT domain_shader(HS_CONSTANT_OUTPUT IN, float3 uvw : SV_DomainLocation, const OutputPatch<HS_OUTPUT, 3> patch){
	DS_OUTPUT OUT = (DS_OUTPUT) 0;

	// if(uvw.x >= 0.1 && uvw.y >= 0.1){
	// 	OUT.discardFlag = true;
	// }

	float3 vertexPosition = patch[0].position.xyz * uvw.x + patch[1].position.xyz * uvw.y + patch[2].position.xyz * uvw.z;

	OUT.position = float4(vertexPosition, 1.0f); //mul(float4(vertexPosition, 1.0f), _World2Object);
	// OUT.tc_Control = patch[0].tc_Control * uvw.x + patch[1].tc_Control * uvw.y + patch[2].tc_Control * uvw.z;
	float2 tc_Control = patch[0].tc_Control * uvw.x + patch[1].tc_Control * uvw.y + patch[2].tc_Control * uvw.z;
	float4 density = tex2Dlod(_Control, float4(tc_Control, 0, 0));
	OUT.density = density;
	OUT.noise = tex2Dlod(_Noise, float4(tc_Control, 0, 0));
	OUT.color = float4(0.0f, OUT.density.r, 0.0f, 1.0f);

	return OUT;
}