/*
  * Copyright (C) 2011 Cameron White
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
  
#ifndef DELETEPOSITION_H
#define DELETEPOSITION_H

#include <QUndoCommand>
#include <boost/shared_ptr.hpp>

class Staff;
class Position;

class DeletePosition : public QUndoCommand
{
public:
    DeletePosition(boost::shared_ptr<Staff> staff, Position* position, quint32 voice);
    void redo();
    void undo();

protected:
    boost::shared_ptr<Staff> staff;
    Position* position;
    const quint32 voice;
};

#endif // DELETEPOSITION_H
