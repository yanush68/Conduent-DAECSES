"""
Apply Fabric-required metadata to the project notebooks.

Fabric (Microsoft Fabric / Synapse Spark) expects:
- A 'parameters'-tagged cell so pipeline TridentNotebook activities can
  inject parameter overrides at run time.
- Top-level kernel/language metadata pinned to synapse_pyspark.
- A 'dependencies.lakehouse' block listing default + known lakehouses so
  spark.read.table("LakehouseName.TableName") resolves cross-lakehouse.

Run this once after editing the .ipynb cells. Idempotent.
"""
from __future__ import annotations
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
HYBRID = ROOT / "fabric-workspace" / "nb_VHybrid_Transforms.Notebook" / "notebook-content.ipynb"
STANDALONE = ROOT / "DACSES_Fabric_Transformations.ipynb"

# Logical IDs that match the lakehouse .platform files in fabric-workspace/.
SOURCE_LH_ID = "44444444-4444-4444-4444-444444444444"
TARGET_LH_ID = "55555555-5555-5555-5555-555555555555"
WORKSPACE_ID = "00000000-0000-0000-0000-000000000000"  # placeholder, swapped per env

FABRIC_TOP_METADATA = {
    "kernel_info": {"name": "synapse_pyspark"},
    "kernelspec": {
        "name": "synapse_pyspark",
        "display_name": "Synapse PySpark",
        "language": "Python",
    },
    "language_info": {"name": "python"},
    "microsoft": {
        "language": "python",
        "language_group": "synapse_pyspark",
        "ms_spell_check": {"ms_spell_check_language": "en"},
    },
    "widgets": {},
    "nteract": {"version": "nteract-front-end@1.0.0"},
    "spark_compute": {
        "compute_id": "/trident/default",
        "session_options": {"conf": {}, "enableDebugMode": False},
    },
}

HYBRID_DEPS = {
    "lakehouse": {
        "default_lakehouse": TARGET_LH_ID,
        "default_lakehouse_name": "TargetLH",
        "default_lakehouse_workspace_id": WORKSPACE_ID,
        "known_lakehouses": [{"id": SOURCE_LH_ID}, {"id": TARGET_LH_ID}],
    }
}


def tag_parameters_cell(nb: dict) -> None:
    """Find the first code cell that defines SOURCE_LAKEHOUSE and tag it."""
    for cell in nb["cells"]:
        if cell.get("cell_type") != "code":
            continue
        src = "".join(cell.get("source", []))
        if "SOURCE_LAKEHOUSE" in src and "TARGET_LAKEHOUSE" in src:
            md = cell.setdefault("metadata", {})
            tags = set(md.get("tags", []))
            tags.add("parameters")
            md["tags"] = sorted(tags)
            return
    raise RuntimeError("No parameters cell found")


def apply(path: pathlib.Path, deps: dict | None) -> None:
    nb = json.loads(path.read_text(encoding="utf-8"))
    nb.setdefault("metadata", {})
    # Merge top-level metadata (preserve anything already there).
    for k, v in FABRIC_TOP_METADATA.items():
        nb["metadata"].setdefault(k, v)
    if deps is not None:
        nb["metadata"]["dependencies"] = deps
    tag_parameters_cell(nb)
    path.write_text(json.dumps(nb, indent=1, ensure_ascii=False), encoding="utf-8")
    print(f"Updated {path.relative_to(ROOT)}")


if __name__ == "__main__":
    apply(HYBRID, HYBRID_DEPS)
    # Standalone notebook isn't called by a pipeline, but the parameters tag
    # and Fabric kernel still help when running it interactively in Fabric.
    apply(STANDALONE, deps=None)
