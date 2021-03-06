//
//  Ease.h
//  FlipBook3D
//
//  Created by xiang huang on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//




/**
 *
 *
 * @param t		Current time (in frames or seconds).
 * @param b		Starting value.
 * @param c		Change needed in value.
 * @param d		Expected easing duration (in frames or seconds).
 * @return		The correct value.
 */
float easeNone (float t, float b, float c, float d) {
	return c*t/d + b;
}


float  easeInQuad (float t, float b, float c, float d) {
	return c*(t/=d)*t + b;
}


float  easeOutQuad (float t, float b, float c, float d) {
	return -c *(t/=d)*(t-2) + b;
}


float  easeInOutQuad (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return c/2*t*t + b;
	return -c/2 * ((--t)*(t-2) - 1) + b;
}




float  easeInCubic (float t, float b, float c, float d) {
	return c*(t/=d)*t*t + b;
}


float  easeOutCubic (float t, float b, float c, float d) {
	return c*((t=t/d-1)*t*t + 1) + b;
}


float  easeInOutCubic (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return c/2*t*t*t + b;
	return c/2*((t-=2)*t*t + 2) + b;
}


float  easeInQuart (float t, float b, float c, float d) {
	return c*(t/=d)*t*t*t + b;
}


float  easeOutQuart (float t, float b, float c, float d) {
	return -c * ((t=t/d-1)*t*t*t - 1) + b;
}


float  easeInOutQuart (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
	return -c/2 * ((t-=2)*t*t*t - 2) + b;
}


float  easeInQuint (float t, float b, float c, float d) {
	return c*(t/=d)*t*t*t*t + b;
}


float  easeOutQuint (float t, float b, float c, float d) {
	return c*((t=t/d-1)*t*t*t*t + 1) + b;
}


float  easeInOutQuint (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
	return c/2*((t-=2)*t*t*t*t + 2) + b;
}


float  easeInSine (float t, float b, float c, float d) {
	return -c * cos(t/d * (M_PI/2)) + c + b;
}


float  easeOutSine (float t, float b, float c, float d) {
	return c * sin(t/d * (M_PI/2)) + b;
}


float  easeInOutSine (float t, float b, float c, float d) {
	return -c/2 * (cos(M_PI*t/d) - 1) + b;
}


float  easeInExpo (float t, float b, float c, float d) {
	return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b - c * 0.001;
}


float  easeOutExpo (float t, float b, float c, float d) {
	return (t==d) ? b+c : c * 1.001 * (-pow(2, -10 * t/d) + 1) + b;
}


float  easeInOutExpo (float t, float b, float c, float d) {
	if (t==0) return b;
	if (t==d) return b+c;
	if ((t/=d/2) < 1) return c/2 * pow(2, 10 * (t - 1)) + b - c * 0.0005;
	return c/2 * 1.0005 * (-pow(2, -10 * --t) + 2) + b;
}


float  easeInCirc (float t, float b, float c, float d) {
	return -c * (sqrt(1 - (t/=d)*t) - 1) + b;
}


float  easeOutCirc (float t, float b, float c, float d) {
	return c * sqrt(1 - (t=t/d-1)*t) + b;
}


float  easeInOutCirc (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return -c/2 * (sqrt(1 - t*t) - 1) + b;
	return c/2 * (sqrt(1 - (t-=2)*t) + 1) + b;
}

float  easeInElastic (float t, float b, float c, float d) {
	if (t==0) return b;
	if ((t/=d)==1) return b+c;
	float p = d*.3;
	int s;
	int a = 0;
	if (a < abs(c)) {
		a = c;
		s = p/4;
	} else {
		s = p/(2*M_PI) * asin (c/a);
	}
	return -(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
}



float  easeOutElastic (float t, float b, float c, float d) {
	if (t==0)		return b;
	if ((t/=d)==1)	return b+c;
	
	//var p:Number = !Boolean(p_params) || isNaN(p_params.period) ? d*.3 : p_params.period;
	float p = d*0.3;
	//var s:Number;
	int s;
	//var a:Number = !Boolean(p_params) || isNaN(p_params.amplitude) ? 0 : p_params.amplitude;
	int a = 0;
	//if (!Boolean(a) || a < abs(c)) {
	if( a < abs(c)){
		a = c;
		s = p/4;
	} else {
		s = p/(2*M_PI) * asin (c/a);
	}
	return (a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b);
}


float  easeInOutElastic (float t, float b, float c, float d) {
	if (t==0) return b;
	if ((t/=d/2)==2) return b+c;
	float p = d*(.3*1.5);
	int s = 0;
	int a = 0;
	if (a < abs(c)) {
		a = c;
		s = p/4;
	} else {
		s = p/(2*M_PI) * asin (c/a);
	}
	if (t < 1) return -.5*(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
	return a*pow(2,-10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )*.5 + c + b;
}

float  easeInBack (float t, float b, float c, float d) {
	//var s:Number = !Boolean(p_params) || isNaN(p_params.overshoot) ? 1.70158 : p_params.overshoot;
	int s = 1.70158;
	return c*(t/=d)*t*((s+1)*t - s) + b;
}


float  easeOutBack (float t, float b, float c, float d) {
	//var s:Number = !Boolean(p_params) || isNaN(p_params.overshoot) ? 1.70158 : p_params.overshoot;
	int s = 1.70158;
	return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
}

float  easeInOutBack (float t, float b, float c, float d) {
	//var s:Number = !Boolean(p_params) || isNaN(p_params.overshoot) ? 1.70158 : p_params.overshoot;
	int s = 1.70158;
	if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
	return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
}

float easeOutBounce (float t, float b, float c, float d)
{
	if ((t/=d) < (1/2.75)) {
		return c*(7.5625*t*t) + b;
	} else if (t < (2/2.75)) {
		return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
	} else if (t < (2.5/2.75)) {
		return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
	} else {
		return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
	}
}

float  easeInBounce (float t, float b, float c, float d) {
	return c - easeOutBounce (d-t, 0, c, d) + b;
}

float  easeInOutBounce (float t, float b, float c, float d) {
	if (t < d/2) return easeInBounce (t*2, 0, c, d) * .5 + b;
	else return easeOutBounce (t*2-d, 0, c, d) * .5 + c*.5 + b;
}


