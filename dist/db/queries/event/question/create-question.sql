
INSERT INTO event.question
(
    event_id,
    user_id,
    text
)

VALUES
(
    $1,
    $2,
    $3
)

RETURNING
    event_id,
    user_id,
    text;
