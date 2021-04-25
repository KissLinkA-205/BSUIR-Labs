package by.epam.web.entity;

public class CalculableParameters {
    private int number;
    private String action;

    public CalculableParameters() {
        this.number = 0;
        this.action = "empty";
    }

    public CalculableParameters(int number, String action) {
        this.number = number;
        this.action = action;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public int getNumber() {
        return this.number;
    }

    public String getAction() {
        return this.action;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        if (getClass() != o.getClass()) return false;

        CalculableParameters calculableParameters = (CalculableParameters) o;
        return ((this.number == calculableParameters.number && this.action.equals(calculableParameters.action)));
    }

    @Override
    public int hashCode() {
        int result = 1;
        result = 31 * result + (int) Double.doubleToLongBits(number);
        result = 31 * result + action.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "\n" + getClass().getName() + "{" +
                "number=" + number +
                ", action='" + action + "}";
    }
}
