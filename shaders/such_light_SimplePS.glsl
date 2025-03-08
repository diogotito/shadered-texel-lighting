#version 330

in vec3 objPosition;
in vec3 objNormal;
in vec2 objUV;
in mat3 tbn;

out vec4 outColor;

uniform vec3 viewPosition;
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
	
	vec3 nView = normalize(viewPosition - pos);
	vec3 nLight = normalize(lightPos - pos);
	vec3 nNormal = normalize(objNormal);
	vec3 nRefl = reflect(-nLight, nNormal);
	
	float dotLN = dot(nLight, nNormal); // Facing ratio
	//dotLN = posterize(dotLN, 4);
	vec3 diffuse = lightDiffuse * dotLN;
	vec3 specular = pow(max(0.0, dot(nView,nRefl)), matShininess) * lightSpecular;
	
	float dst = distance(lightPos, pos);
	float attn = 1./(1.0f + 0.1f*dst + 0.01f*dst*dst);

	vec3 color = ((diffuse + specular)*attn + lightAmbient)*matColor;
	
	vec2 texelUV = posterize(objUV);
 	
 	// [DEBUG] Overlay texelUV
 	color += vec3(abs(dFdx(texelUV)) + abs(dFdy(texelUV)), 0.0);
	
	// Posterize the color
	// color = floor(color * texRes) / texRes;
	
	outColor = vec4(color, 1.0f);
}