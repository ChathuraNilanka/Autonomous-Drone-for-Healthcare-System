// drone trip modles
export interface Trip{
    lat?: number;
    lon?: number;
    alt?: number;
    battery?: number;
    status?: string;
    isArmed?: boolean;
    velocity?: any;
    isArrived?: boolean
}

export interface SetLocetion{
    lat?: number;
    lon?: number;
    alt?: number;
}

