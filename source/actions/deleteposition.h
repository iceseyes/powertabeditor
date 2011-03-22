#ifndef DELETEPOSITION_H
#define DELETEPOSITION_H

#include <QUndoCommand>
#include <memory>

class Staff;
class Position;

class DeletePosition : public QUndoCommand
{
public:
    DeletePosition(Staff* staff, Position* position, quint32 voice);
    void redo();
    void undo();

protected:
    Staff* staff;
    Position* position;
    std::unique_ptr<Position> positionCopy;
    const quint32 voice;
};

#endif // DELETEPOSITION_H
