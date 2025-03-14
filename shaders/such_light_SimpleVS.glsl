#version 330

#ifndef NORMAL_STRETCH
#define NORMAL_STRETCH 0.04
#endif

uniform mat4 matView;
uniform mat4 matVP;
uniform mat4 matGeo;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 tangent;
layout (location = 3) in vec3 bitangent;
layout (location = 4) in vec2 texcoord;

out vec3 objPosition;
out vec3 viewPosition;
out vec3 objNormal;
out vec2 objUV;
out vec4 debugNormal;

void main() {
   objNormal = (matGeo * vec4(normal, 0)).xyz;
   objPosition = (matGeo * vec4(pos, 1)).xyz;
   viewPosition = (matView * (matGeo * vec4(pos, 1))).xyz;
   objUV = texcoord;
   gl_Position = matVP * matGeo * vec4(pos, 1);
   debugNormal = matVP * matGeo * vec4(pos + NORMAL_STRETCH * normal, 1);
}
