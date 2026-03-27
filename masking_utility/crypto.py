from __future__ import annotations

import base64
import hashlib
from cryptography.fernet import Fernet, InvalidToken

TOKEN_PREFIX = "ENC::"


class CryptoManager:
    """Handles reversible masking and unmasking of cell values."""

    def __init__(self, pass_phrase: str) -> None:
        self._fernet = Fernet(self._derive_key(pass_phrase))

    @staticmethod
    def _derive_key(pass_phrase: str) -> bytes:
        digest = hashlib.sha256(pass_phrase.encode("utf-8")).digest()
        return base64.urlsafe_b64encode(digest)

    def mask(self, value: str) -> str:
        if value.startswith(TOKEN_PREFIX):
            return value
        token = self._fernet.encrypt(value.encode("utf-8")).decode("utf-8")
        return f"{TOKEN_PREFIX}{token}"

    def unmask(self, value: str) -> str:
        if not value.startswith(TOKEN_PREFIX):
            return value

        token = value[len(TOKEN_PREFIX) :]
        try:
            return self._fernet.decrypt(token.encode("utf-8")).decode("utf-8")
        except InvalidToken:
            raise ValueError("Unable to unmask value; pass phrase or content is invalid.")
