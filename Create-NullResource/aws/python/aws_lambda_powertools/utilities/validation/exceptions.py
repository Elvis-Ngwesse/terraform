from __future__ import annotations

from typing import Any

from aws_lambda_powertools.exceptions import InvalidEnvelopeExpressionError


class SchemaValidationError(Exception):
    """When serialization fail schema validation"""

    def __init__(
        self,
        message: str | None = None,
        validation_message: str | None = None,
        name: str | None = None,
        path: list | None = None,
        value: Any | None = None,
        definition: Any | None = None,
        rule: str | None = None,
        rule_definition: Any | None = None,
    ):
        """When serialization fail schema validation

        Parameters
        ----------
        message : str, optional
            Powertools for AWS Lambda (Python) formatted error message
        validation_message : str, optional
            Containing human-readable information what is wrong
            (e.g. `data.property[index] must be smaller than or equal to 42`)
        name : str, optional
            name of a path in the data structure
            (e.g. `data.property[index]`)
        path: list, optional
            `path` as an array in the data structure
            (e.g. `['data', 'property', 'index']`),
        value : Any, optional
            The invalid value
        definition : Any, optional
            The full rule `definition`
            (e.g. `42`)
        rule : str, optional
            `rule` which the `data` is breaking
            (e.g. `maximum`)
        rule_definition : Any, optional
            The specific rule `definition`
            (e.g. `42`)
        """
        super().__init__(message)
        self.message = message
        self.validation_message = validation_message
        self.name = name
        self.path = path
        self.value = value
        self.definition = definition
        self.rule = rule
        self.rule_definition = rule_definition


class InvalidSchemaFormatError(Exception):
    """When JSON Schema is in invalid format"""


__all__ = ["SchemaValidationError", "InvalidSchemaFormatError", "InvalidEnvelopeExpressionError"]
