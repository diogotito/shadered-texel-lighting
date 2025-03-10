#version 330

#ifndef TRIANGLE_SIZE
#define TRIANGLE_SIZE 0.02
#endif

layout(triangles) in;
layout(triangle_strip, max_vertices=12) out;

in vec3 objPosition[];
in vec3 viewPosition[];
in vec3 objNormal[];
in vec2 objUV[];
in vec4 debugNormal[];

out float fIsDebug;
out vec3 fObjPosition;
out vec3 fViewPosition;
out vec3 fObjNormal;
out vec2 fObjUV;

void PassthroughVariablesForVertex(int i) {
	fObjPosition = objPosition[i];
	fViewPosition = viewPosition[i];
	fObjNormal = objNormal[i];
	fObjUV = objUV[i];
	gl_Position = gl_in[i].gl_Position;
}

void POINT(vec4 point) {
	gl_Position = point;
	EmitVertex();
}

void MakeArrow(vec4 base, vec4 tip) {
	vec4 dir = normalize(tip - base);
	vec4 perp = vec4(dir.y, -dir.x, dir.z, dir.w);

	// Line, triangle 1
	//POINT(base.xy - 0.01 * perp);
	//POINT(base.xy + 0.01 * perp);
	//POINT(tip.xy + 0.01 * perp);
	POINT(base);
	POINT(tip);
	POINT(vec4(base.xy + vec2(0.01, 0.00), 0.0, 0.0));
	EndPrimitive();
	
	// Line, triangle 2
	

}

void main() {
	fIsDebug = 0.0;
	for (int i = 0; i < 3; i++) {
		PassthroughVariablesForVertex(i);
		EmitVertex();
	}
	EndPrimitive();

	#ifdef DEBUG
	fIsDebug = 1.0;
	for (int i = 0; i < 3; i++) {
		PassthroughVariablesForVertex(i);
		MakeArrow(/* base */ gl_in[i].gl_Position, /* tip */ debugNormal[i]);
	}
	#endif
}