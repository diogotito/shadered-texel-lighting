#version 330
// https://discussions.unity.com/t/the-quest-for-efficient-per-texel-lighting/700574/9

in vec3 objPosition;
in vec3 viewPosition;
in vec3 objNormal;
in vec2 objUV;

out vec4 outColor;

uniform vec3 cameraPosition;
uniform vec3 matColor;
uniform float matShininess;
uniform vec3 lightPos;
uniform vec3 lightAmbient;
uniform vec3 lightDiffuse;
uniform vec3 lightSpecular;

uniform int texRes;

vec2  posterize(vec2  v, int n) { return floor(v * n) / n; }
vec3  posterize(vec3  v, int n) { return floor(v * n) / n; }
float posterize(float v, int n) { return floor(v * n) / n; }
vec2  posterize(vec2  v) { return posterize(v, texRes); }
vec3  posterize(vec3  v) { return posterize(v, texRes); }
float posterize(float v) { return posterize(v, texRes); }

void main() {
	vec3 pos = objPosition;
	
	// 1.)
	vec2 originalUV = objUV;
	vec2 centerUV = posterize(originalUV) + (0.5 / texRes);
	vec2 dUV = centerUV - originalUV;
	
	// 2a.)
	vec3 originalWorldPos = pos;
	
	// 2b.)
	vec2 dUVdS = dFdx(originalUV);
	vec2 dUVdT = dFdy(originalUV);
	
	// 2c.)
	mat2 dSTdUV = mat2(dUVdT[1], -dUVdT[0], -dUVdS[1], dUVdS[0]) * (1.0f/(dUVdS[0]*dUVdT[1]-dUVdT[0]*dUVdS[1]));
	
	// 2d.)
	vec2 dST = dSTdUV * dUV;
	
	// 2e.)
	vec3 dXYZdS = dFdx(originalWorldPos);
	vec3 dXYZdT = dFdy(originalWorldPos);
	
	// 2f.)
	vec3 dXYZ = dXYZdS * dST[0] + dXYZdT * dST[1];
	dXYZ = clamp(dXYZ, -1, 1);
	
	// 3.)
	vec3 snappedWorldPos = originalWorldPos + dXYZ;
	// UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);
	
	// 4.)
	
	
	// -----------------------------------------------
	
	vec3 nView  = normalize(cameraPosition - pos);
	vec3 nView2 = normalize(cameraPosition - snappedWorldPos);
	vec3 nLight  = normalize(lightPos - pos);
	vec3 nLight2 = normalize(lightPos - snappedWorldPos);
	vec3 nNormal  = normalize(objNormal);
	vec3 xTangent = dFdx(viewPosition);
	vec3 yTangent = dFdy(viewPosition);
	vec3 nNormal2 = normalize(cross( xTangent, yTangent ));
	vec3 nRefl  = reflect(-nLight, nNormal);
	vec3 nRefl2 = reflect(-nLight2, nNormal2);
	
	float dotLN  = dot(nLight, nNormal);   // Facing ratio
	float dotLNFlat = dot(nLight, nNormal2);
	dotLN = dotLNFlat;
	float dotLN2 = dot(nLight2, nNormal2); // Facing ratio, snapped edition
	vec3 diffuse  = lightDiffuse * dotLN;
	vec3 diffuse2 = lightDiffuse * dotLN2;
	vec3 specular  = pow(max(0.0, dot(nView , nRefl )), matShininess) * lightSpecular;
	vec3 specular2 = pow(max(0.0, dot(nView2, nRefl2)), matShininess) * lightSpecular;
	
	float dst  = distance(lightPos, pos);
	float dst2 = distance(lightPos, snappedWorldPos);
	float attn  = 1./(1.0f + 0.1f * dst  + 0.01f * dst  * dst );
	float attn2 = 1./(1.0f + 0.1f * dst2 + 0.01f * dst2 * dst2);

	vec3 color  = ((diffuse  + specular ) * attn  + lightAmbient) * matColor;
	vec3 color2 = ((diffuse2 + specular2) * attn2 + lightAmbient) * matColor;
	
	#ifdef DEBUG
 	vec2 texelUV = posterize(objUV);
 	vec3 border = vec3(abs(dFdx(texelUV)) + abs(dFdy(texelUV)), 0.0);
	float center = smoothstep(0.992, 0.996, 1-length(dUV));
	color2 = snappedWorldPos;
	color += border; color2 += border; color += center; color2 += center;
	#endif
	
	outColor = vec4(color, 0.0f);
	outColor = vec4(color2, 1.0f);
}