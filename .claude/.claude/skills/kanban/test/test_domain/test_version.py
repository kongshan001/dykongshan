from __future__ import annotations
import re
from core.domain.version import VersionManager


class TestVersionManager:
    def test_valid_version_name(self):
        assert VersionManager.is_valid("v0.1.0") is True
        assert VersionManager.is_valid("v1.2.3") is True
        assert VersionManager.is_valid("0.1.0") is False
        assert VersionManager.is_valid("V0.1.0") is False

    def test_ensure_v_prefix(self):
        assert VersionManager.ensure_v_prefix("0.1.0") == "v0.1.0"
        assert VersionManager.ensure_v_prefix("v1.0.0") == "v1.0.0"

    def test_parse_version(self):
        v = VersionManager.parse("v1.2.3")
        assert v == (1, 2, 3)

    def test_version_pattern(self):
        assert re.match(VersionManager.PATTERN, "v0.1.0") is not None
        assert re.match(VersionManager.PATTERN, "0.1.0") is None
