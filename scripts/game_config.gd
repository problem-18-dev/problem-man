extends Node


enum Phase { Chase, Scatter }

const PHASES := {
	Phase.Chase: "Chase",
	Phase.Scatter: "Scatter",
}

const PHASE_TO_GHOST_STATE_MAP: Dictionary[Phase, Ghost.State] = {
	Phase.Chase: Ghost.State.Chase,
	Phase.Scatter: Ghost.State.Scatter,
}
