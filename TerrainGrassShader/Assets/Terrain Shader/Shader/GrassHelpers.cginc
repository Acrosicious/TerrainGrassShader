// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// **************************************************************
// Data structures												*
// **************************************************************
struct VS_INPUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD0;
};

struct VS_OUTPUT
{
	float4 position	: POSITION;

	float2 tc_Control : TEXCOORD4;
	float4 color : COLOR;
	float density : NUMBER;
};

struct HS_OUTPUT
{
	float4 position	: TEXCOORD1;

	float2 tc_Control : TEXCOORD4;
	float4 color : COLOR;
	float density : NUMBER;
};

struct DS_OUTPUT
{
	float4 position	: POSITION;

	// float2 tc_Control : TEXCOORD4;
	float noise : NOISE;
	float4 color : COLOR;
	float4 density : NUMBER;
	bool discardFlag : BOOL;
};

struct HS_CONSTANT_OUTPUT				{
	float EdgeFactors[3] : SV_TessFactor;
	float InsideFactor : SV_InsideTessFactor;
};

struct GS_OUTPUT
{
	float4 pos	: POSITION;
	float2 tex : TEXCOORD0;
	float4 color : COLOR;
	float3 normal : NORMAL;
	float3 tangent : TANGENT;
	float3 worldPos : POSITION2;
	float cutout : FLOAT; // For transition between patch sizes
	int id : INTEGER; // Number of billboard in patch
	bool ground : BOOL;
	int type : INTEGER2;
};

struct GrassBillboard
{
	GS_OUTPUT vertices[4];
};

struct VertexStruct
{
	float4 vertex : POSITION;
	float3 normal : NORMAL;
};

// **************************************************************
// Variables											        *
// **************************************************************

float _WindDirectionDegrees;
float _windEnabled;
float _UpDown;

float3 _colPos;
float _colRad;

float3 _colPos0;
float _colRad0;
float3 _colPos1;
float _colRad1;
float3 _colPos2;
float _colRad2;
float3 _colPos3;
float _colRad3;
float3 _colPos4;
float _colRad4;
float3 _colPos5;
float _colRad5;
float3 _colPos6;
float _colRad6;
float3 _colPos7;
float _colRad7;
float3 _colPos8;
float _colRad8;
float3 _colPos9;
float _colRad9;

float _colliderCount;

float _Debug2;

sampler2D _Noise;
sampler2D _CameraDepthTexture;


float _NoiseInfluence;

float _Tess;

sampler2D _GrassTex1;
float4 _Healthy1;
float4 _Dry1;
float _Height1;
float _Width1;

sampler2D _GrassTex2;
float4 _Healthy2;
float4 _Dry2;
float _Height2;
float _Width2;

sampler2D _GrassTex3;
float4 _Healthy3;
float4 _Dry3;
float _Height3;
float _Width3;

sampler2D _GrassTex4;
float4 _Healthy4;
float4 _Dry4;
float _Height4;
float _Width4;

float _tex1Enabled;
float _tex2Enabled;
float _tex3Enabled;
float _tex4Enabled;

float _Density;
float _DensityWeight;

float _MaxCameraDistance;
float _TriBillboardDistance;
float _transitionDistance;

float _AlphaCutoff;

float _faceCamera;

//float4x4 _VP;

float _Ambient;
float _Diffuse;
float _Specular;
float _SpecularSize;

float _ShadowIntensity;
float _ShadowBillboardDistance;
float _moreBB;
float _lessBB;
float _hdrOn;


float _Debug; // 0 - 2
// float _Debug2; // 0 - 1
float _Debug100; // 0 - 100
float _DebugToggle;

// #if defined (DIRECTIONAL) || defined(SHADOWS_DEPTH) || (defined(SHADOWS_CUBE) && defined(SHADOW_ACTIVE)) || defined(SHADOWS_CUBE)
// 	uniform float4x4 unity_WorldToLight; // transformation 
// #endif

// **************************************************************
// Functions											        *
// **************************************************************

#define TRANSFER_SHADOW_CASTER_NOPOS2(opos, vertex) \
            opos = mul(UNITY_MATRIX_VP, vertex); \
            opos = UnityApplyLinearShadowBias(opos);

// #define TRANSFER_SHADOW2(a) ;
#define TRANSFER_SHADOW2(a) a._ShadowCoord = mul( unity_WorldToShadow[0], a.worldPos );

float4 getColData(int i) {
	switch (i) {
	case 0: return float4(_colPos0, _colRad0);
	case 1: return float4(_colPos1, _colRad1);
	case 2: return float4(_colPos2, _colRad2);
	case 3: return float4(_colPos3, _colRad3);
	case 4: return float4(_colPos4, _colRad4);
	case 5: return float4(_colPos5, _colRad5);
	case 6: return float4(_colPos6, _colRad6);
	case 7: return float4(_colPos7, _colRad7);
	case 8: return float4(_colPos8, _colRad8);
	case 9: return float4(_colPos9, _colRad9);
	}

	return float4(0, 0, 0, 0);
}

GrassBillboard generateGrassBillboardVertices(float4 position, float density, float2 size, float rotation){

	density = 0.9f * density + 0.1f;

	// half Width
	float halfS = 0.5f * size.x * density;

	// UP
	float3 up = float3(0, 1, 0);

	// Apply rotation
	float a = rotation;

	float s = sin(a);
	float c = cos(a);
	float3x3 rot3 = float3x3(
		c, 0.0f, s,
		0.0f, 1.0f, 0.0f,
		-s, 0.0f, c);
	
	float3 right = mul(float3(1.0f, 0.0f, 1.0f), rot3);

	// Wind
	float4 additiveWindVector = float4(0.0f, 0.0f, 0.0f, 0.0f);
	// calculate direction from degrees
	float rad = radians(_WindDirectionDegrees);
	float2 windDirection = normalize(float2(cos(rad), sin(rad)));

	// strength of the wind
	float windStrength = 0.2f;

	if(_windEnabled){
		float delta = length(position.xz * windDirection.xy) / 1.0f; // maybe change to wind location calculation
		float windFac = ((sin(_Time * 10.0f + delta) + 1.0f)/2.0f); 
		additiveWindVector = float4(windDirection.x * windStrength * windFac, 0.0f, windDirection.y * windStrength * windFac, 0.0f);
	}

	// New vertices
	float4 vertices[4];
	vertices[0] = float4(position + halfS * right  - size.y * density * up * _UpDown, 1.0f);
	vertices[1] = float4(position - halfS * right  - size.y * density * up * _UpDown, 1.0f);					
	vertices[2] = float4(position + halfS * right  + size.y * density * up * (1.0 - _UpDown), 1.0f); 
	vertices[3] = float4(position - halfS * right  + size.y * density * up * (1.0 - _UpDown), 1.0f);

	// Normal vector
	float3 normal;
	normal = normalize(cross(vertices[1] - vertices[0], vertices[2] - vertices[0]));
	float3 tangent = normalize(vertices[1] - vertices[0]);

	// Translation: move billboard out of center
	float4x4 vmat = float4x4(vertices);
	
	float4 row = float4(normal * halfS / 2.0 * density, 0.0f);
	float4x4 transMat = float4x4(row, row, row, row);
	
	vmat = vmat + transMat;
	vertices[0] = vmat[0];
	vertices[1] = vmat[1];
	vertices[2] = vmat[2];
	vertices[3] = vmat[3];

	// Slanting - bend grass in -normal direction

	float deg = 0.35f * pow(density, 4); // Bend more if view from top TODO
	deg = 0.35;// * pow(density, 4);

	// Collision - add bending by proximity to collider
	float4 botCenter = (vertices[0] + vertices[1]) / 2.0f; // Bottom center of grass
	float colDist = distance(botCenter, _colPos); // distance to collider
	float3 tempN = normalize(vertices[2] - vertices[0]); // FERNANDO

	float bend = 0.0f;
	/*
	if(colDist <= _colRad){
		float d = colDist / _colRad;
		float bending = 1.0f - pow(d, 1.5f);

		deg += bending;

	}
	*/
	for (int i = 0; i < _colliderCount; i++) {
		float4 dat = getColData(i);
		colDist = distance(botCenter, dat.xyz); // distance to collider
		if (colDist <= dat.w) {
			float d = colDist / dat.w;
			float bending = 1.0f - pow(d, 1.5f);

			bend = min(1.0f, bend + bending);
			

		}
	}

	deg += bend;

	// do the bending
	a = deg * 3.1415f / 2.0f;

	s = sin(a);
	c = cos(a);

	size.y = halfS;
	float4 trans = float4(size.y * -normal.x * s, size.y * density * -(1.0f - c), size.y * -normal.z * s, 0.0f);

	vertices[2] += trans;
	vertices[3] += trans;


	// add wind
	vertices[2] += additiveWindVector;
	vertices[3] += additiveWindVector;
	
	normal = tempN;	

	GrassBillboard OUT = (GrassBillboard) 0;

	// mul(vp, obj) => position in scene
	//float4x4 vp = UnityObjectToClipPos(unity_WorldToObject);

	// Transfer SHADOW
	VertexStruct v = (VertexStruct) 0;
	v.normal = normal;

	GS_OUTPUT gsOUT = (GS_OUTPUT) 0;

	[unroll]
	for(int i = 0; i < 4; i++){
		gsOUT.pos = UnityObjectToClipPos(vertices[i]); //mul(vp, vertices[i]);
		gsOUT.tex = float2(i % 2, i / 2);
		gsOUT.normal = normal;
		gsOUT.tangent = tangent;
		gsOUT.worldPos = vertices[i].xyz;
		OUT.vertices[i] = gsOUT;
	}

	return OUT;
}

float rand(float3 co)
{
    return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) )) * 43758.5453);
}

float2 rand2(float3 co)
{
	float2 o;
	o.x = frac(sin( dot(co.xyz ,float3(15.1231,77.925,37.1315) )) * 28945.8942);
	o.y = frac(sin(dot(co.xyz ,float3(17.4657,73.741,27.4123))) * 89732.1827);
	return o;
}

float3 rand3(float3 co)
{
	float3 o;
	o.x = rand(co);
	float2 r = rand2(co);
	o.y = r.x;
	o.z = r.y;
	return o;
}

float triangleArea(float4 x, float4 y, float4 z){
	// Area triangle Herons formula
	float3 vLength[3];
	vLength[0] = length(x - y);
	vLength[1] = length(x - z);
	vLength[2] = length(y - z);

	float sd = 0.5f * (vLength[0] + vLength[1] + vLength[2]);
	float area = sqrt(sd * (sd - vLength[0]) * (sd - vLength[1]) * (sd - vLength[2]));

	return area;
}

GrassBillboard generateGrassBillboard(float4 position, float density, float2 size, float rotation){
	GrassBillboard OUT = (GrassBillboard) 0;

	OUT = generateGrassBillboardVertices(position, density, size, rotation);

	return OUT;
}

/* Get a random position inside a triangle
 * http://mathworld.wolfram.com/TrianglePointPicking.html
 * x y z are the corner vertices
 * r = a random float2
 *		 		 
 */ 
float4 getRandomPointInTriangle(float4 x, float4 y, float4 z, float2 r){
	float4 OUT;

	x -= z;
	y -= z;

	OUT = x * r.x + y * r.y;
	OUT += z;
	OUT.a = 1.0f;
	return OUT;
}

